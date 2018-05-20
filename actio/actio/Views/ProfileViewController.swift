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
  
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var addImageButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    weekLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    totalLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    monthLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

    guard let user = Auth.auth().currentUser else { return }
    // check is facebook profile found?
    if let _ = FBSDKAccessToken.current() {
      if let currentUser = FBSDKProfile.current() {
        print("Found current facebook user: \(currentUser)")
      } else {
        print("facebook user not found")
        FBSDKProfile.loadCurrentProfile(completion: {
          profile, error in
          if let updatedUser = profile {
            print("updated facebook user found: \(updatedUser)")
          } else {
            print("still no user)
          }
        })
      }
    }
  }
}
