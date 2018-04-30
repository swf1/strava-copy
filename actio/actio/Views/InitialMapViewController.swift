//
//  InitialMapViewController.swift
//  actio
//
//  Created by Jason Hoffman on 4/30/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class InitialMapViewController: UIViewController {

    
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    
    var locationManager: CLLocationManager!
    var regionRadius: CLLocationDistance = 500
    var coordinateArray = [CLLocationCoordinate2D]()
    var cam = MGLMapCamera()
    var course: Double = 0.0
    var totalDistance = 0.0
    var log = false
    var courseView = false
    var firstLast: [CLLocationCoordinate2D]?  // for start and end coordinate. should be added to activity object
    // For simulated reading from DB
    let fileManager = FileManager.default
    var paceArray = [Double]() // To calc average pace
    var df = DateComponentsFormatter()  // For time display
    var currentLocation: CLLocation? = nil // use this instead of locationmanager.location
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // CLLocationManager setup
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // Battery expensive
        locationManager.activityType = .fitness
        locationManager.startUpdatingLocation()  // Tie 'GPS active' to this in delegate method
        
        // MapBox setup
        mapView.delegate = self
        mapView.isPitchEnabled = true
        mapView.showsHeading = false
        mapView.compassView.isHidden = true
        mapView.attributionButton.isHidden = true
        mapView.logoView.isHidden = true
        
    }
    
    // Hide status bar at top when modal seuges
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

}

// MARK: MGLMapViewDelegate
extension InitialMapViewController: MGLMapViewDelegate {
    
}

// MARK: CLLocationManagerDelegate
extension InitialMapViewController: CLLocationManagerDelegate {
    
}
