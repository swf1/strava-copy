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
  @IBOutlet weak var goToTrackRun: UIView!

  var chooseViewActivityType: String!
  let locationManager = Loc.shared

  override func viewDidLoad() {
    super.viewDidLoad()
    chooseView.isHidden = true
    self.titleBar.title = "Welcome"
  }
  
  
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
    self.chooseView.isHidden = false
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
      //uid = user.uid;  // The user's ID, unique to the Firebase project. Do NOT use
      // this value to authenticate with your backend server, if
      // you have one. Use User.getToken() instead.
      //self.profileImage.image = UIImage(data: NSData(contentsOf: photoUrl! as URL)! as Data)
      //self.nameLabel.text = (data["name"]! as? String)!
      guard let user = Auth.auth().currentUser else { return }
      guard let name = user.displayName else { return }
      guard let photo = user.photoURL else { return }
      guard let uid = user.uid as? String else { return  }
      guard let email = user.email as? String else { return }
      let athlete = Athlete(uid: uid, email: email, name: name, photo: photo)
      vc.activity = Activity(athlete: athlete, type: chooseViewActivityType)

      if let flag = locationManager.gpsFlag {
        flag.0 ? (vc.labelColor = UIColor.green) : (vc.labelColor = UIColor.red)
        vc.labelText = flag.1
      }
    }
    
    
    if let vc = segue.destination as? ProfileViewController
    {
      guard let user = Auth.auth().currentUser else { return }
      vc.name = user.displayName 
      vc.photo = user.photoURL
    }
    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    chooseView.isHidden = true
  }
  
}


