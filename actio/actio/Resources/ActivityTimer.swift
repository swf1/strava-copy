//
//  ActivityTimer.swift
//  actio
//
//  Created by Jason Hoffman on 4/30/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

class ActivityTimer {
    
    var totalDistance = 0.0
    var paceArray = [Double]()
    var coordinateArray = [CLLocationCoordinate2D]()
    var df = DateComponentsFormatter()
    var currentLocation: CLLocation?
    
    func pace() -> String {
        if let loc = currentLocation {
            let mps = Measurement(value: loc.speed, unit: UnitSpeed.metersPerSecond)
            let mph = mps.converted(to: .milesPerHour)
            let paceInSeconds = 3600.0 / mph.value
            paceArray.append(paceInSeconds)
            guard let formattedPace = df.string(from: paceInSeconds) else { return "?:??" }
            return formattedPace
        }
        
        return "?:??"
    }
    
    func avgPace() -> String {
        let s = paceArray.reduce(0.0, +)
        let avg = s / Double(paceArray.count)
        guard let avgPace = df.string(from: avg) else { return "?:??" }
        return avgPace
    }
    
    func totalDistance(newLocation: CLLocation) {
        if let last = coordinateArray.last {  // Using paceArray here for now
            let loc = CLLocation(latitude: last.latitude, longitude: last.longitude)
            var dist = Measurement(value: newLocation.distance(from: loc), unit: UnitLength.meters)
            dist = dist.converted(to: .miles)
            totalDistance += dist.value
        }
    }
    
    func appendCoordinate(_ coordinate: CLLocationCoordinate2D) {
        coordinateArray.append(coordinate)
    }
}
