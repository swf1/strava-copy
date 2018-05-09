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

    var activity: Activity!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var gpsLabel: UILabel!
    @IBOutlet weak var gpsLabelHeightConstraint: NSLayoutConstraint! // for animation
    
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
        mapView.isPitchEnabled = false
        mapView.compassView.isHidden = true
        mapView.attributionButton.isHidden = true
        mapView.logoView.isHidden = true
        
        if locationManager.locServicesEnabled() {
            mapView.showsUserLocation = true
        } else {
            centerButton.isHidden = true // prevent crash
            let osu = CLLocationCoordinate2D(latitude: 44.5638, longitude: -123.2794)
            let noLoc = MGLMapCamera(lookingAtCenter: osu, fromDistance: 2000, pitch: 0.0, heading: 0.0)
            mapView.fly(to: noLoc, completionHandler: nil)
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gpsFlag()
//        if mapView.isUserLocationVisible {
//            centerMap()
//        }
    }
    
    
    @IBAction func startButtonPressed(_ sender: Any) {
        locationManager.logging = true // not a great solution for this
        activityTimer.startTime()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StartActivityViewController
        {
            vc.activity = self.activity
        }
    }
    
    @IBAction func centerButtonPressed(_ sender: Any) {
        centerMap()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gpsFlag() {
        if let flag = locationManager.gpsFlag {
            // Animation needed to change after view loads?
            UIView.animate(withDuration: 0.5) {
                // Still need a green color
                flag.0 ? (self.gpsLabel.backgroundColor = UIColor.green) : (self.gpsLabel.backgroundColor = UIColor.red)
                self.gpsLabel.text = flag.1
                self.gpsLabelHeightConstraint.constant = 41
            }
        }
    }
    
    // app will crash with this called and location
    // services disabled
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
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        if mapView.isUserLocationVisible {
            centerMap()
        }
    }
    
    
//    func mapView(_ mapView: MGLMapView, didFailToLocateUserWithError error: Error) {
//        <#code#>
//    }
    
}
