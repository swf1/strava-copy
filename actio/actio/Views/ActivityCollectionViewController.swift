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

class ActivityCollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.clientTable .dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
    return cell
  }
  
  
  var ref: DatabaseReference!
  fileprivate var _refHandle: DatabaseHandle?
  @IBOutlet weak var activityCollectionView: UICollectionView!
  @IBOutlet weak var chooseView: UIView!
  @IBOutlet weak var clientTable: UITableView!
  var chooseViewActivityType: String!
  var activities: [DataSnapshot]! = []
  
  @IBOutlet weak var goToTrackRun: UIView!
  
  @IBAction func showChooseView(_ sender: AnyObject) {
    chooseView.isHidden = false
    // might add a greyscale to make the background look unavailble.
    // this would also be a large button to unselect the pop up
    // there is likely a better ios/swift way of doing this so I'm waiting.
  }
  @IBAction func hideChooseView(_ sender: AnyObject) {
    chooseView.isHidden = true
    // when we leave the screen we need to rehide the pop up prompt
    // removing it upon return is too slow.
  }
    
  @IBAction func didPressRun() {
    self.chooseViewActivityType = "Run"
  }

  @IBAction func didPressBike() {
    self.chooseViewActivityType = "Bike"
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? InitialMapViewController
    {
      guard let user = Auth.auth().currentUser else { return }
      guard let uid = user.uid as? String else { return  }
      guard let email = user.email as? String else { return }
      let athlete = Athlete(uid: uid, email: email)
      vc.activity = Activity(athlete: athlete, type: chooseViewActivityType)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    chooseView.isHidden = true
    activityCollectionView.delegate = self
    activityCollectionView.dataSource = self
    self.ref = Database.database().reference()
    
    guard let user = Auth.auth().currentUser else { return }
    _refHandle = self.ref.child("activities").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
      guard let strongSelf = self else { return }
      guard let activity = snapshot.value as? [String:Any?] else { return }
      guard let athlete = activity["athlete"] as? [String:Any?] else { return }
      print(athlete["uid"])
//      strongSelf.activities.append(snapshot)
//      strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.activities.count-1, section: 0)], with: .automatic)
    })
  }
  
  override func viewDidDisappear(_ animated: Bool) {
      chooseView.isHidden = true
  }
}


extension ActivityCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath)
    return cell
  }
}


func didPressButtonFromCustomView(sender:UIButton) {
  // do whatever you want
  // make view disappears again, or remove from its superview
}
