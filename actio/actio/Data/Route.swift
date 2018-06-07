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
import CoreLocation

class Route: NSObject {
    var name: String?
    var coordinates: [CLLocation]
    
    init?(coordinates: [CLLocation]) {
        self.coordinates = coordinates
    }
    
    init?(name: String, coordinates: [CLLocation]) {
        self.name = name
        self.coordinates = coordinates
    }
}
