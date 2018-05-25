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
    private var locationArray = [CLLocation]()
    private var df = DateComponentsFormatter()
    private var firstLast = [CLLocationCoordinate2D]()
    
    var totalDistance = 0.0
    var counter = 0.0
    
    // Must call before using
    func config() {
        timer = Repeater.every(.seconds(1.0), { _ in
            self.counter += 1.0
            // Sends notification with each tick that's picked up by other VCs
            NotificationCenter.default.post(name: Notification.Name("Tick"), object: nil, userInfo: ["time": self.totalTime()])
        })
        timer.pause()
        df.allowedUnits = [.minute, .second]
        df.zeroFormattingBehavior = [.pad]
        df.unitsStyle = .positional
        
        if !paceArray.isEmpty { paceArray = [Double]() }
        if !locationArray.isEmpty { locationArray = [CLLocation]() }
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
        if let last = locationArray.last {  // Using paceArray here for now
            let loc = CLLocation(latitude: last.coordinate.latitude, longitude: last.coordinate.longitude)
            var dist = Measurement(value: newLocation.distance(from: loc), unit: UnitLength.meters)
            dist = dist.converted(to: .miles)
            totalDistance += dist.value  // don't round to keep accuracy. round in view controller
        }
    }
    
    func totalTime() -> String {
        let c = Measurement(value: counter, unit: UnitDuration.seconds)
        guard let tot = df.string(from: c.value) else { return "?:??" }
        return tot
    }


    func startTime() {
        timer.start()
    }
    
    func pause() {
        timer.pause()
        // for use if the user ends their activity
        if locationArray.count > 1 {
            firstLast = [locationArray[0].coordinate, locationArray.last?.coordinate] as! [CLLocationCoordinate2D]
        }
    }
    
    func appendLocation(_ location: CLLocation) {
        locationArray.append(location)
        currentLocation = location
    }
    
    // nil if empty
    func coordinates() -> [CLLocation]? {
        // has to be > 1 or MGLPolyline will crash
        if locationArray.count > 1 {
            return locationArray
        }
        
        return nil
    }
}
