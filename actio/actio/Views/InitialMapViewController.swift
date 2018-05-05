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

// This view controller only needs to show the user's location. On 'play', the
// view segues to another MGLMapView that will take care of tracking

class InitialMapViewController: UIViewController {

    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    let locationManager = Loc.shared
    let activityTimer = ActivityTimer.shared
    var regionRadius: CLLocationDistance = 500
    var coordinateArray = [CLLocationCoordinate2D]()
    var cam = MGLMapCamera()
    var log = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.startLogging()
        activityTimer.config()

        // MapBox setup
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        mapView.isPitchEnabled = true // not needed here
        mapView.showsHeading = false // not needed here
        mapView.compassView.isHidden = true
        mapView.attributionButton.isHidden = true
        mapView.logoView.isHidden = true
        mapView.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if mapView.isUserLocationVisible {
            centerMap()
        }
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        locationManager.logging = true // not a great solution for this
        activityTimer.startTime()
    }
    
    @IBAction func centerButtonPressed(_ sender: Any) {
        centerMap()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func centerMap() {
        if let loc = mapView.userLocation {
            mapView.setCenter(loc.coordinate, zoomLevel: 15.0, animated: true)
            UIView.animate(withDuration: 0.2) {
                self.centerButton.alpha = 0.0
            }
        }
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
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
    }
    
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.centerButton.alpha = 1.0
        }
    }
}
