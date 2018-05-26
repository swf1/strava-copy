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
  var route: Route?
  var athlete: Athlete?
  var name: String?
  var type: String?
  var startDateLocal: String?

  init(snapshot: DataSnapshot) {
    let activityData = snapshot.value as? [String:AnyObject] ?? [:]
    self.name = activityData["name"] as? String
    self.type = activityData["type"] as? String
  }

  init?(athlete: Athlete, type: String) {
    self.athlete = athlete
    self.type = type
  }
}
