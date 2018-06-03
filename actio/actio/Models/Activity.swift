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
import FirebaseDatabase

class Activity: NSObject {
    var uid: String?
    var route: Route?
    var athlete: Athlete
    var name: String?
    var type: String
    //var distance: 
    //var manual_distance: UInt64
    //var manual_time: String
    //var manual_pace: UIInt64
    var startDateLocal: String?
    
    init(athlete: Athlete, type: String) {
        self.athlete = athlete
        self.type = type
    }

//    init(athlete: Athlete, name: String, type: String, startDateLocal: String) {
//        self.athlete = athlete
//        self.name = name
//        self.type = type
//        self.startDateLocal = startDateLocal
//    }
//
//    init?(
//        uid: String,
//        athlete: Athlete,
//        name: String,
//        type: String,
//        startDateLocal: String
//    ) {
//        self.uid = uid
//        self.athlete = athlete
//        self.name = name
//        self.type = type
//        self.startDateLocal = startDateLocal
//    }
//
//    init?(
//        uid: String,
//        athlete: Athlete,
//        name: String,
//        type: String,
//        startDateLocal: String,
//        route: Route
//    ) {
//        self.uid = uid
//        self.athlete = athlete
//        self.name = name
//        self.type = type
//        self.startDateLocal = startDateLocal
//        self.route = route
//    }
}
