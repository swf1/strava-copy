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

class Route: NSObject {
    var name: String?
    var coordinates: [Coordinate]
    
    init?(coordinates: [Coordinate]) {
        self.coordinates = coordinates
    }
    
    init?(name: String, coordinates: [Coordinate]) {
        self.name = name
        self.coordinates = coordinates
    }
}
