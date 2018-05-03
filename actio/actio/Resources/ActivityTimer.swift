//
//  ActivityTimer.swift
//  actio
//
//  Created by Jason Hoffman on 4/30/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation
import Repeat

class ActivityTimer {
    
    static let shared = ActivityTimer() 
    
    private var currentLocation: CLLocation?
    private var timer: Repeater!
    private var paceArray = [Double]()
    private var coordinateArray = [CLLocationCoordinate2D]()
    private var df = DateComponentsFormatter()

    var totalDistance = 0.0
    var counter = 0.0
    
    // Must call before using
    func config() {
        timer = Repeater.every(.seconds(1.0), { _ in
            self.counter += 1.0
            print(String(self.counter))
        })
    }
    
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
    
    func totalTime() -> String {
        let c = Measurement(value: counter, unit: UnitDuration.seconds)
        let totalTime = c.converted(to: .minutes)
        guard let formattedTime = df.string(from: totalTime.value) else { return "?:??" }
        return formattedTime
    }
    
    func startTime() {
        timer.start()
    }
    
    func pause() {
        timer.pause()
    }
    
    func appendCoordinate(_ coordinate: CLLocationCoordinate2D) {
        coordinateArray.append(coordinate)
    }
}
