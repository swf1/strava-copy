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

final class FirebaseDataStore {

  static let instance = FirebaseDataStore()
  fileprivate init() {}

  var activities: [Activity] = []
  var currentActivity: Activity!

  func getActivities(onCompletion: @escaping () -> Void) {
    FirebaseClient.observeActivities { (snapshot) in
      let activity = Activity(snapshot: snapshot)
      self.activities.append(activity)
      onCompletion()
    }
  }

  func saveActivity(activity: Activity) {
    var coordinates: [[String:Double]] = []
    for c in activity.route!.coordinates {
      coordinates.append([
        "latitude": c.coordinate.latitude,
        "longitude": c.coordinate.longitude
      ])
    }
    let data: [String:Any?] = [
      "name": activity.name,
      "type": activity.type,
      "start_date_local": activity.startDateLocal,
      "route": ["coordinates": coordinates],
      "pace": activity.pace,
      "distance": activity.distance
    ]
    FirebaseClient.saveActivity(activityData: data)
  }
}
