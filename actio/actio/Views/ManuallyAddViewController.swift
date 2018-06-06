//
//  ManuallyAddViewController.swift
//  actio
//
//  Created by Alieta Train on 5/19/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit
import Firebase

class ManualAddViewController: UIViewController {
  
  var activity: Activity!
  var chooseViewActivityType: String!
  var milesFract: Int!

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
    let milesFractInt = Int(sender.value)
    //let milesFractDouble = Double(milesFractInt)
    //self.milesFract = Double(milesFractDouble / 10.0)

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
      self.chooseViewActivityType = "bike";
    case 1:
      self.chooseViewActivityType = "run";
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
    milesFracStepper.maximumValue = 9
  }
  
  // record manual activity *needs work on distance and time*
  @IBAction func subimtManualActivity(_ sender: UIButton) {
    // perform saving functions here
    guard let user = Auth.auth().currentUser else { return }
    print("user", user)
    guard let uid = user.uid as? String else { return  }
    print("uid", uid)
    guard let name = user.displayName else { return }
    guard let photo = user.photoURL else { return }
    guard let email = user.email as? String else { return }
    let athlete = Athlete(uid: uid, email: email, name: name, photo: photo)
    print("athelete", athlete)
    //let activity = Activity(athlete: athlete, type: chooseViewActivityType)
    let distanceWhole = milesWholeLabel.text!
    let distanceFract = milesFract
    print("distanceWhole", distanceWhole)
    print("distanceFract", distanceFract)
    /*let time = Int(hoursLabel.text!)! * 60 + Int(minutesLabel.text!)!
    let activityName: String = activityNameField.text!
    self.activity.name = activityName
    var data: [String:Any] = [:]
    //data["distance"] =
    //data["time"] =
    data["type"] = activity.type
    data["name"] = activity.name
    data["athlete"] = ["uid": activity.athlete.uid]
    data["start_date_local"] = activity.startDateLocal*/
  }
}

