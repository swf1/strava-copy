//
//  ProfileViewController.swift
//  actio
//
//  Created by Alieta Train on 5/19/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit


class ProfileViewController: UIViewController {
  var activity: Activity!

  // these are for user profile
  var name: String!
  var photo: URL!

  // total labels
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var totalPaceLabel: UILabel!
  @IBOutlet weak var totalDistanceLabel: UILabel!
  // weekly labels
  @IBOutlet weak var weeklyTime: UILabel!
  @IBOutlet weak var weeklyDistance: UILabel!
  @IBOutlet weak var weeklyPace: UILabel!
  // monthly labels
  @IBOutlet weak var weekLabel: UILabel!
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  
  @IBAction func logoutUserClicked(_ sender: Any) {
    print("clicked")
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
      print("logged out");
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    weekLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    totalLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    monthLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    self.nameLabel.text = name
    let imageURL = photo
    // only programatically assign profile values if they exist (social auth) 
    if imageURL != nil {
      if let data = try? Data(contentsOf: imageURL!) {
        if let image = UIImage(data: data) {
            self.profileImage.image = image
        }
      }
    }
  }
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    if UIDevice.current.orientation.isLandscape {
      print("Landscape")
    } else {
      print("Portrait")
    }
  }
}
