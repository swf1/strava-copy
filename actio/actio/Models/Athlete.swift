//
//  Activity.swift
//  actio
//
//  Contributors:
//    Alieta Train
//    Tyler Mcginnis on 5/5/18.
//    Jason Hoffman
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation

class Athlete: NSObject {
    var uid: String
    var email: String
    var name: String
    var photo: URL

  init(uid: String, email: String, name: String, photo: URL) {
      self.uid = uid
      self.email = email
      self.name = name
      self.photo = photo
    }
}
