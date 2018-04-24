//
//  Activity.swift
//  actio
//
//  Contributors:
//    Alieta Train
//    Tyler Mcginnis on 4/21/18.
//    Jason Hoffman
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Activity: NSObject {
    var uid: String
    var name: String
    var type: String
    var startDateLocal: String
    var activityDescription: String
    var elapsedTime: Int?
    var distance: String?
    var visible: Bool?
    var trainer: Bool?
    var commute: Bool?

    init(uid: String, name: String, type: String, startDateLocal: String, description: String) {
        self.uid = uid
        self.name = name
        self.type = type
        self.startDateLocal = startDateLocal
        self.activityDescription = description
    }

    init?(snapshot: DataSnapshot) {
        guard let uid = snapshot.key as? String else { return nil }
        guard let params = snapshot.value as? [String:Any] else { return nil }
        guard let name = params["name"] as? String else { return nil }
        guard let type = params["type"] as? String else { return nil }
        guard let startDateLocal = params["start_date_local"] as? String else { return nil }
        guard let description = params["description"] as? String else { return nil }

        self.uid = uid
        self.name = name
        self.type = type
        self.startDateLocal = startDateLocal
        self.activityDescription = description
    }
}
