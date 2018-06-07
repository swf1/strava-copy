//
//  Activity.swift
//  actio
//
//  Contributors:
//    Alieta Train
//    Tyler Mcginnis
//    Jason Hoffman
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import Firebase

struct Activity{
  var uid: String?
  var name: String?
  var type: String?
  var startDateLocal: String?
  var route: Route?
  var athlete: Athlete?
  var distance: String?
  var pace: String?
  var duration: String?
  var screenshotLabel: String?

  init(snapshot: DataSnapshot) {
    let activityData = snapshot.value as? [String:AnyObject] ?? [:]
    self.uid = snapshot.key
    self.name = activityData["name"] as? String ?? ""
    self.type = activityData["type"] as? String ?? ""
    self.startDateLocal = activityData["start_date_local"] as? String ?? ""
    self.distance = activityData["distance"] as? String ?? ""
    self.pace = activityData["pace"] as? String ?? ""
    self.duration = activityData["duration"] as? String ?? ""
    self.screenshotLabel = activityData["screenshot_label"] as? String ?? ""
  }

  init(type: String, startDateLocal: String) {
    self.type = type
    self.startDateLocal = startDateLocal
  }

  init(athlete: Athlete, type: String) {
    self.athlete = athlete
    self.type = type
  }

}
