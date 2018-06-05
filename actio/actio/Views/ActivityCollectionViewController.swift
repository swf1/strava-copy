//
//  ActivityCollectionViewController.swift
//  actio
//
//  Created by Alieta Train on 4/29/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ActivityCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

  let store = FirebaseDataStore.instance
  let locationManager = Loc.shared
  var chooseViewActivityType: String!

  @IBOutlet weak var activityCollectionView: UICollectionView!
  @IBOutlet weak var clientTable: UITableView!
  @IBOutlet weak var goToTrackRun: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    activityCollectionView.delegate = self
    activityCollectionView.dataSource = self
    store.getActivities {
      self.activityCollectionView.reloadSections(IndexSet(integer: 0))
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {}
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return store.activities.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath)
      as! ActivityCollectionViewCell
    let activity = store.activities[indexPath.row]
    cell.displayContent(name: activity.name!, type: activity.type!, distance: activity.distance!, pace: activity.pace!)
    return cell
  }
}

func didPressButtonFromCustomView(sender:UIButton) {
  // do whatever you want
  // make view disappears again, or remove from its superview
}
