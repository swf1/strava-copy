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
  let store = FirebaseDataStore.instance
  let locationManager = Loc.shared
  let activityTimer = ActivityTimer.shared
  
  var ref: DatabaseReference!
  
  override func viewDidLoad() {
    self.ref = Database.database().reference()
  }

  @IBOutlet weak var activityNameField: UITextField!
  @IBOutlet weak var recordActivityButton: UIButton!
  
  @IBAction func recordActivityPressed(_ sender: Any) {
    // perform saving functions here
    let activityName: String = activityNameField.text!
    self.activity.name = activityName
//    var coordinates: [[String:Double]] = []
//    for l in activityTimer.coordinates()! {
//      coordinates.append([
//        "latitude": l.coordinate.latitude,
//        "longitude": l.coordinate.longitude
//        ])
//    }
//    data["route"] = ["coordinates": coordinates]
    store.saveActivity(activity: activity)
//    self.ref.child("activities").childByAutoId().setValue(data)
  }
  // allows user to touch off keyboar to hide keyboard
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
//    let name = activityNameField.text!
//    activity.name = name
//    let route = Route(coordinates: activityTimer.coordinates()!)
//    store.currentActivity.route = route
//    store.saveActivity(activity: activity)
    // go to activity view
//    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityCollectionViewController")
//    self.present(vc!, animated: true, completion: nil)
  }
}
