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
  
  @IBOutlet weak var activityNameField: UITextField!
  @IBOutlet weak var milesWholeLabel: UILabel!
  @IBOutlet weak var milesWholeStepper: UIStepper!
  @IBAction func milesWholeStepperChanged(_ sender: UIStepper) {
    milesWholeLabel.text = Int(sender.value).description
  }
  
  @IBOutlet weak var milesFracStepper: UIStepper!
  @IBOutlet weak var milesFractLabel: UILabel!
  @IBAction func milesFracStepperChanged(_ sender: UIStepper) {
    milesFractLabel.text = Int(sender.value).description
  }
  
  // time hours
  @IBOutlet weak var minutesLabel: UILabel!
  @IBOutlet weak var minutesStepper: UIStepper!
  @IBAction func stepperValueChanged(_ sender: UIStepper) {
    hoursLabel.text = Int(sender.value).description
  }
  
  // time minutes
  @IBOutlet weak var hoursLabel: UILabel!
  @IBOutlet weak var hoursStepper: UIStepper!
  @IBAction func minutesValueChanged(_ sender: UIStepper) {
    minutesLabel.text = Int(sender.value).description
  }

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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hoursStepper.wraps = true
    hoursStepper.autorepeat = true
    hoursStepper.maximumValue = 10
    
    minutesStepper.wraps = true
    minutesStepper.autorepeat = true
    minutesStepper.maximumValue = 60
    
    milesWholeStepper.wraps = true
    milesWholeStepper.autorepeat = true
    milesWholeStepper.maximumValue = 50
    
    milesFracStepper.wraps = true
    milesFracStepper.autorepeat = true
    milesFracStepper.maximumValue = 99
  }
  
  // record manual activity *needs work on distance and time*
  @IBAction func submitManualActivityPressed(_ sender: AnyObject) {
    // perform saving functions here
    
    let distance = milesFractLabel.text! + milesWholeLabel.text!
    let time = Int(hoursLabel.text!)! * 60 + Int(minutesLabel.text!)!
    let activityName: String = activityNameField.text!
    self.activity.name = activityName
    var data: [String:Any] = [:]
    data["type"] = activity.type
    data["name"] = activity.name
    data["athlete"] = ["uid": activity.athlete.uid]
    data["start_date_local"] = activity.startDateLocal
  }
}

