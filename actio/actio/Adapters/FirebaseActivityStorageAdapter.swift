//
//  FirebaseActivityStorageAdapter.swift
//  actio
//
//  Created by Tyler McGinnis on 5/5/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import Firebase

class FirebaseActivityStorageAdapter: ActivityStorageAdapter {
    var ref: DatabaseReference!

    init() {
        ref = Database.database().reference()
    }

    func save(activity: Activity) {
        let serializer = ActivitySerializer()
        let data = serializer.createMap(fromActivity: activity)
        ref.child("activity").childByAutoId().setValue(data)
    }

    func update(activity: Activity) {
        if let uid = activity.uid {
            let serializer = ActivitySerializer()
            let data = serializer.createMap(fromActivity: activity)
            ref.child("activity").child(uid).setValue(data)
        }
    }

    func delete(activity: Activity) {
        if let uid = activity.uid {
            ref.child("activities").child(uid).removeValue()
        }
    }
}
