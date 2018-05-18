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

// container collection container view
// and profile container view
class CoreViewController: UIViewController {
  
  @IBOutlet weak var activityCollectionView: UICollectionView!
  // containers
  @IBOutlet weak var manualAddContainerView: UIView!
  @IBOutlet weak var activityCollectionContainerView: UIView!
  @IBOutlet weak var profileContainerView: UIView!
  // hidden choose type of activity view
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
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    chooseView.isHidden = true
  }
  
  
  //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  //        if segue.identifier == "activitySegue" {
  //            if let flag = locationManager.gpsFlag, let vc = segue.destination as? InitialMapViewController {
  //                flag.0 ? (vc.gpsLabel.backgroundColor = UIColor.green) : (vc.gpsLabel.backgroundColor = UIColor.red)
  //                vc.gpsLabel.text = flag.1
  //            }
  //        }
  //    }
}


