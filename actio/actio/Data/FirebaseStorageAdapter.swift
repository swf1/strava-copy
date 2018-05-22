//
//  FirebaseEncoder.swift
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

class FirebaseStorageAdapter {
  var ref: DatabaseReference

  init() {
    self.ref = Database.database().reference()
  }

  func activities(forAthlete athleteUID: String) -> DatabaseReference {
    return self.ref.child("activities").child(athleteUID)
  }
}
