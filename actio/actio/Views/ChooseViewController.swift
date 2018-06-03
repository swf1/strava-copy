//
//  ChooseViewController.swift
//  actio
//
//  Created by Alieta Train on 5/31/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit
import Firebase

class ChooseViewController: UIViewController {

  var chooseViewActivityType: String!
  let locationManager = Loc.shared
  //@IBOutlet weak var chooseView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view?.backgroundColor = UIColor(white: 1, alpha: 0.7)

  }

  @IBAction func dismissVC(_ sender: Any) {
    dismiss(animated: true, completion: nil)
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
  }
}
