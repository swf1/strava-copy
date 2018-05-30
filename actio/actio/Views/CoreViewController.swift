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
  @IBOutlet weak var titleBar: UINavigationItem!
  @IBOutlet weak var activityCollectionView: UICollectionView!
  // containers
  @IBOutlet weak var manualAddContainerView: UIView!
  @IBOutlet weak var activityCollectionContainerView: UIView!
  @IBOutlet weak var profileContainerView: UIView!
  // hidden choose type of activity view
  @IBOutlet weak var chooseView: UIView!
  @IBOutlet weak var manualAddButton: UIBarButtonItem!
  @IBOutlet weak var profileButton: UIBarButtonItem!
  @IBOutlet weak var homeButton: UIBarButtonItem!
  var chooseViewActivityType: String!
  @IBOutlet weak var goToTrackRun: UIView!
  let locationManager = Loc.shared
    
  @IBAction func showProfileView(sender: UIBarButtonItem) {
    self.titleBar.title = "Your profile"
    if (self.profileContainerView.alpha == 0) {
      UIView.animate(withDuration: 0.5, animations: {
        self.profileContainerView.alpha = 1
        self.manualAddContainerView.alpha = 0
        self.activityCollectionContainerView.alpha = 0
      })
    }
  }
  
  @IBAction func showManualAddView(sender: UIBarButtonItem) {
    self.titleBar.title = "Manually add activity"
    if (self.manualAddContainerView.alpha == 0) {
      UIView.animate(withDuration: 0.5, animations: {
        self.profileContainerView.alpha = 0
        self.manualAddContainerView.alpha = 1
        self.activityCollectionContainerView.alpha = 0
      })
    }
  }
  
  @IBAction func showActivityCollectionView(sender: UIBarButtonItem) {
    self.titleBar.title = "Your activities"
    if (self.activityCollectionContainerView.alpha == 0) {
      UIView.animate(withDuration: 0.5, animations: {
        self.profileContainerView.alpha = 0
        self.manualAddContainerView.alpha = 0
        self.activityCollectionContainerView.alpha = 1
      })
    }
  }
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
        
      if let flag = locationManager.gpsFlag {
        flag.0 ? (vc.gpsLabel.backgroundColor = UIColor.green) : (vc.gpsLabel.backgroundColor = UIColor.red)
        vc.gpsLabel.text = flag.1
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    chooseView.isHidden = true
    self.titleBar.title = "Welcome"
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    chooseView.isHidden = true
  }
}


