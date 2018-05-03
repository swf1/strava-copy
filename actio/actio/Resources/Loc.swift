//
//  Loc.swift
//  actio
//
//  Created by Jason Hoffman on 5/1/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import CoreLocation

// This is a CLLocationManager singleton for use in sharing
// location between multiple view controllers

class Loc: NSObject, CLLocationManagerDelegate {
    
    static let shared = Loc()
    
    private let locationManager: CLLocationManager
    let activityTimer = ActivityTimer.shared
    var currentLocation: CLLocation?
    var locationArray: [CLLocation]?
    var isGPSActive: Bool? // For 'gps active' flag
    var logging = false
    
    override init() {
        locationManager = CLLocationManager()
        locationArray = [CLLocation]()
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.delegate = self
    }
    
    func startLogging() {
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            // This isn't working right
//            let howRecent = loc.timestamp.timeIntervalSinceNow
//            guard loc.horizontalAccuracy < 5 && abs(howRecent) < 10 else { return }
            currentLocation = loc
            if logging { activityTimer.appendCoordinate(loc.coordinate) }
        }
    }
    
}
