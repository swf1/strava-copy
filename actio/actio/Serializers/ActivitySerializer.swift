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
import Firebase

class ActivitySerializer {
    static func createMap(fromActivity activity: Activity) -> [String:Any?] {
        return [
            "name": activity.name,
            "type": activity.type,
            "start_date_local": activity.startDateLocal,
            "athlete": [
                "uid": activity.athlete.uid
            ]
        ]
    }
}
