//
//  Route.swift
//  actio
//
//  Created by Tyler McGinnis on 5/5/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation

class Route: NSObject {
    var name: String?
    var coordinates: [Coordinate]
    
    init() {
        self.coordinates = [Coordinate]
    }
    
    init?(coordinates: [Coordinate]) {
        self.coordinates = coordinates
    }
    
    init?(name: String, coordinates: [Coordinate]) {
        self.name = name
        self.coordinates = coordinates
    }
}
