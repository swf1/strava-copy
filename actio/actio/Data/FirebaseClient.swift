//
//  FirebaseClient.swift
//  actio
//
//  Created by Tyler McGinnis on 5/26/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

struct FirebaseClient {
  static func observeActivities(onChildAdded: @escaping (DataSnapshot) -> Void) {
    let ref = Database.database().reference()
    guard let user = Auth.auth().currentUser else { return }
    ref.child("activities").child(user.uid).observe(.childAdded, with: onChildAdded)
  }
  
  static func saveActivity(activityData: [String:Any?]) {
    let ref = Database.database().reference()
    guard let user = Auth.auth().currentUser else { return }
    ref.child("activities").child(user.uid).childByAutoId().setValue(activityData)
  }
  
  static func storeScreenshot(label: String, screenshot: UIImage) {
    let ref = Storage.storage().reference()
    let snapshotRef = ref.child(label)
    let data = UIImageJPEGRepresentation(screenshot, 0.8)
    snapshotRef.putData(data!, metadata: nil) { (metadata, error) in
      guard let metadata = metadata else {
        return
      }
      let size = metadata.size
    }
  }
}
