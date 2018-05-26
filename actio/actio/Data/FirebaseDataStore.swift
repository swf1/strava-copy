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

  func getActivities(onCompletion: @escaping () -> Void) {
    FirebaseClient.observeActivities { (snapshot) in
      let activity = Activity(snapshot: snapshot)
      self.activities.append(activity)
      onCompletion()
    }
  }
}
