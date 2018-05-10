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
    var gpsFlag: (Bool, String)? 
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
    
    func locServicesEnabled() -> Bool {
        if  CLLocationManager.authorizationStatus() == .denied ||
            CLLocationManager.authorizationStatus() == .restricted ||
            CLLocationManager.authorizationStatus() == .notDetermined {
            return false
        }
        
        return true
    }
    
    func isGPSActive(err: CLError) {
        switch err.code {
        case .locationUnknown:
            gpsFlag = (false, "Location unavailable")
        case .denied:
            gpsFlag = (false, "Location services disabled")
        default:
            gpsFlag = (true, "GPS is Active")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            gpsFlag = (true, "GPS is Active")
            // This isn't working right
//            let howRecent = loc.timestamp.timeIntervalSinceNow
//            guard loc.horizontalAccuracy < 5 && abs(howRecent) < 10 else { return }
            currentLocation = loc
            if logging {
                activityTimer.totalDistance(newLocation: loc) // here so keeps track in background
                // only append activity coordinates here to avoid dupes
                activityTimer.appendLocation(loc)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError")
        if let err = error as? CLError {
            isGPSActive(err: err)
        }
    }
    
}
