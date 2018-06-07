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
  var activityScreenshot: UIImage?
  let store = FirebaseDataStore.instance
  let locationManager = Loc.shared
  let activityTimer = ActivityTimer.shared

  @IBOutlet weak var activityNameField: UITextField!
  @IBOutlet weak var recordActivityButton: UIButton!
  
  @IBAction func recordActivityPressed(_ sender: Any) {
    self.activity.name = activityNameField.text!
    self.activity.route = Route(coordinates: self.activityTimer.coordinates()!)
    self.activity.pace = self.activityTimer.pace()
    self.activity.distance = String(format: "%.2f", self.activityTimer.totalDistance)
    self.activity.duration = self.activityTimer.totalTime()
    self.activity.screenshotLabel = UUID().uuidString + ".jpg"
    
    if let p = parent as? StartActivityViewController {
        if let img = p.activityScreenshot {
          store.storeScreenshot(
            label: self.activity.screenshotLabel!,
            screenshot: img
          )
        }
    }
    
    store.saveActivity(activity: activity)
  }

  // allows user to touch off keyboar to hide keyboard
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}
