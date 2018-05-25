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
  
  @IBOutlet weak var logoutButton: UIButton!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  
  
  @IBAction func logoutUser(sender: UIButton) {
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    weekLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    totalLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    monthLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

    // check if facebook user, if so use profile image, first, and last for profile
    if FBSDKAccessToken.current() != nil {
      let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
      graphRequest?.start(completionHandler: {
        (connection, result, error) -> Void in
        if ((error) != nil)
        {
          print("Error: \(String(describing: error))")
        }
        else if error == nil
        {
          let data:[String:AnyObject] = result as! [String : AnyObject]
          let facebookID: NSString = (data["id"]! as? NSString)!
          self.nameLabel.text = (data["name"]! as? String)!
          let url = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1")
          self.profileImage.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
        }
      })
    }
    // check if google user if so source profile image, first, last as profile details
  }
}
