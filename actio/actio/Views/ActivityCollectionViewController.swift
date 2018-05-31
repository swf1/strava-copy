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

class ActivityCollectionViewController: UIViewController {
    
  let locationManager = Loc.shared

  @IBOutlet weak var activityCollectionView: UICollectionView!
  
  @IBOutlet weak var chooseView: UIView!
  var chooseViewActivityType: String!
  
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
  
    @IBAction func unwindToActivityCollectionView(segue: UIStoryboardSegue){}
  

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InitialMapViewController
        {
            guard let user = Auth.auth().currentUser else { return }
            guard let uid = user.uid as? String else { return  }
            guard let email = user.email as? String else { return }
            let athlete = Athlete(uid: uid, email: email)
            vc.activity = Activity(athlete: athlete, type: chooseViewActivityType)
            if let flag = locationManager.gpsFlag {
                flag.0 ? (vc.gpsLabel.backgroundColor = UIColor.green) : (vc.gpsLabel.backgroundColor = UIColor.red)
                vc.gpsLabel.text = flag.1
            }
        }
    }

  override func viewDidLoad() {
    super.viewDidLoad()
    activityCollectionView.delegate = self
    activityCollectionView.dataSource = self
  }
  
  override func viewDidDisappear(_ animated: Bool) {
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
