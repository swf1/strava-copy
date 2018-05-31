//
//  ManuallyAddViewController.swift
//  actio
//
//  Created by Alieta Train on 5/19/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit

class ManualAddViewController: UIViewController {
  
  
  var activity: Activity!
  
  @IBOutlet weak var submitManualEntryButton: UIButton!
  @IBOutlet weak var timeInput: UITextField!
  @IBOutlet weak var distanceInput: UITextField!
  @IBOutlet weak var activityTypeSegment: UISegmentedControl!
  @IBOutlet weak var activityNameInput: UITextField!
  
  // get and set activity type
  @IBAction func typeChanged(_ sender: AnyObject) {
    switch activityTypeSegment.selectedSegmentIndex
    {
    case 0:
      activity.type = "bike";
    case 1:
      activity.type = "run";
    default:
      break
    }
  }
  
  // record manual activity *needs work on distance and time*
  @IBAction func recordManualActivityPressed(_ sender: AnyObject) {
    // perform saving functions here
    let activityName: String = activityNameInput.text!
    self.activity.name = activityName
    var data: [String:Any] = [:]
    data["type"] = activity.type
    data["name"] = activity.name
    data["athlete"] = ["uid": activity.athlete?.uid]
    data["start_date_local"] = activity.startDateLocal
  }
}

