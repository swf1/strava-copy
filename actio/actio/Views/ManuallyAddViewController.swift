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
  let store = FirebaseDataStore.instance

  @IBOutlet weak var activityNameInputField: UITextField!
  @IBOutlet weak var submitManualEntryButton: UIButton!
  @IBOutlet weak var activityTypeSegment: UISegmentedControl!
  @IBOutlet weak var timeField: UITextField!
  @IBOutlet weak var distanceField: UITextField!
  
  @IBOutlet weak var distanceWarning: UILabel!
  @IBOutlet weak var timeWarning: UILabel!
  @IBOutlet weak var nameWarning: UILabel!
  
  // get and set activity type
  @IBAction func typeChanged(_ sender: AnyObject) {
    switch activityTypeSegment.selectedSegmentIndex
    {
    case 0:
      self.chooseViewActivityType = "bike";
      print("choose view type", chooseViewActivityType)
    case 1:
      self.chooseViewActivityType = "run";
      print("choose view type", chooseViewActivityType)
    default:
      break
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.chooseViewActivityType = "run";
    
    distanceWarning.isHidden = true
    timeWarning.isHidden = true
    nameWarning.isHidden = true
  }
  
  @IBAction func validateInput(_ sender: UIButton) {
    if timeField.text == nil || timeField.text == ""  {
        timeWarning.isHidden = false
        print("time", timeField.text)
    } else {
      timeWarning.isHidden = true
    }
    if distanceField.text == nil || distanceField.text == "" {
        distanceWarning.isHidden = false
        print("distance", distanceField)
    } else {
      distanceWarning.isHidden = true
    }
    if activityNameInputField.text == nil || activityNameInputField.text == "" {
        nameWarning.isHidden = false
        print("name", activityNameInputField)
    } else {
      nameWarning.isHidden = true
    }
    if (activityNameInputField.text != ""  && distanceField.text != "" && timeField.text != "") {
      print("going for it")
      submitManualActivity()
    }
  }
  
  // record manual activity *needs work on distance and time*
  func submitManualActivity() {
    // perform saving functions here
    guard let user = Auth.auth().currentUser else { return }
    guard let uid = user.uid as? String else { return  }
    guard let displayName = user.displayName else { return }
    guard let photo = user.photoURL else { return }
    guard let email = user.email else { return }
    let athlete = Athlete(uid: uid, email: email, displayName: displayName, photo: photo)
  
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormatter.dateFormat(
      fromTemplate: "MMddyyyy",
      options: 0,
      locale: Locale(identifier: "en-US")
    )
    activity = Activity(
      type: chooseViewActivityType,
      startDateLocal: formatter.string(from: Date())
    )

    self.activity.name = activityNameInputField.text!
    let time = timeField.text
    let distance = distanceField.text
    var dur = Double(time!)
    let d1 = (dur!/60.0).rounded(.towardZero)
    let intd1 = Int(d1)
    let d2 = (dur?.truncatingRemainder(dividingBy: 60.0))!
    let intd2 = Int(d2)
    let durString = "\(intd1):\(intd2)"
    let dis = Double(distance!)
    let p1 = (dur! / dis!).rounded(.towardZero)
    let intP1 = Int(p1)
    let p2 = (dur?.truncatingRemainder(dividingBy: dis!))!
    let intP2 = Int(p2)
    self.activity.duration = durString
    self.activity.distance = distance
    self.activity.pace = "\(intP1):\(intP2)"
    store.saveActivity(activity: activity)
    performSegue(withIdentifier: "unwindToCoreView", sender: self)

  }
}

