//
//  SaveActivityViewController.swift
//  actio
//
//  Created by Alieta Train on 5/13/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox
import Firebase


class SaveActivityViewController: UIViewController {
  var activity: Activity!
  var ref: DatabaseReference!
  let locationManager = Loc.shared

  let activityTimer = ActivityTimer.shared

  @IBOutlet weak var activityNameField: UITextField!
  @IBOutlet weak var recordActivityButton: UIButton!
  
  override func viewDidLoad() {
    self.ref = Database.database().reference()
  }
  
  @IBAction func recordActivityPressed(_ sender: Any) {
    // perform saving functions here
    let activityName: String = activityNameField.text!
    self.activity.name = activityName
    var data: [String:Any] = [:]
    data["type"] = activity.type
    data["name"] = activity.name
    data["athlete"] = ["uid": activity.athlete.uid]
    data["start_date_local"] = activity.startDateLocal
    var coordinates: [[String:Double]] = []
    for l in activityTimer.coordinates()! {
      coordinates.append([
        "latitude": l.coordinate.latitude,
        "longitude": l.coordinate.longitude
        ])
    }
    data["route"] = ["coordinates": coordinates]
    self.ref.child("activities").childByAutoId().setValue(data)
  }
  // allows user to touch off keyboar to hide keyboard
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}
