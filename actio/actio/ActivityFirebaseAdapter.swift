//
//  ActivityFirebaseAdapter.swift
//  actio
//
//  Contributors:
//    Alieta Train
//    Tyler Mcginnis on 4/21/18.
//    Jason Hoffman
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import Firebase

class ActivityFirebaseAdapter {
    var ref: DatabaseReference!
    fileprivate var _refHandle: DatabaseHandle!

    init() {
        self.ref = Database.database().reference()
    }

    deinit {
        //
    }

    func getActivities(athleteUid: String) {
        //
    }

    func getActivity(uid: String) {
        //
    }

    func saveActivity(activity: Activity) {
        var data: [String:Any] = [:]
        data["type"] = activity.type
        data["name"] = activity.name
        data["description"] = activity.activityDescription
        data["start_date_local"] = activity.startDateLocal
        self.ref.child("activities").child(activity.uid).setValue(data)
    }

    func deleteActivity(activity: Activity) {
        //
    }
}
