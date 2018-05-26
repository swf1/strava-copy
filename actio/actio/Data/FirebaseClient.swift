//
//  FirebaseClient.swift
//  actio
//
//  Created by Tyler McGinnis on 5/26/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseClient {
  static func observeActivities(onChildAdded: @escaping (DataSnapshot) -> Void) {
    let ref = Database.database().reference()
    guard let user = Auth.auth().currentUser else { return }
    ref.child("activities").child(user.uid).observe(.childAdded, with: onChildAdded)
  }
}
