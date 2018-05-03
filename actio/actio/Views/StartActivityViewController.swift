//
//  StartActivityViewController.swift
//  actio
//
//  Created by Jason Hoffman on 5/1/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox

class StartActivityViewController: UIViewController {
    
    let locationManager = Loc.shared
    let activityTimer = ActivityTimer.shared
    let time = 0.0
    var paused = false
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var mapToggleButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide save and resume buttons
        saveButton.isHidden = true
        resumeButton.isHidden = true
        
        // MapBox setup again
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        mapView.isPitchEnabled = true // not needed here
        mapView.showsHeading = false // not needed here
        mapView.compassView.isHidden = true
        mapView.attributionButton.isHidden = true
        mapView.logoView.isHidden = true
        mapView.showsUserLocation = true
        
        // Will receive notification from ActivityTimer
        NotificationCenter.default.addObserver(self, selector: #selector(updateTime(_:)), name: Notification.Name("Tick"), object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        courseMode()
    }
    

    @IBAction func pauseButtonPressed(_ sender: Any) {
        // Pause/play animation should go here
        toggleButtons()
        activityTimer.pause()
        paused = !paused
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        // perform saving functions here
    }
    
    @IBAction func resumeButtonPressed(_ sender: Any) {
        toggleButtons()
        // and go back to activity
    }
    
    @objc func updateTime(_ notification: Notification) {
        if let t = notification.userInfo?["time"] as? String {
            // has to be on main thread
            DispatchQueue.main.async {
                self.elapsedTimeLabel.text = t
            }
        }
    }
    
    func toggleButtons() {
        // this should become an animation
    
        pauseButton.isHidden = !pauseButton.isHidden
        saveButton.isHidden = !saveButton.isHidden
        resumeButton.isHidden = !resumeButton.isHidden
        mapToggleButton.isHidden = !mapToggleButton.isHidden
    }
    
    func courseMode() {
        mapView.userTrackingMode = .followWithCourse
        mapView.setCamera(
            MGLMapCamera(
                lookingAtCenter: mapView.userLocation!.coordinate,
                fromDistance: 500,
                pitch: 70.0,
                heading: mapView.camera.heading),
            animated: true
        )
    }
    // Hide status bar at top when modal seuges
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

}


extension StartActivityViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        if paused { return }
        
        paceLabel.text = activityTimer.pace()
        distanceLabel.text = String(activityTimer.totalDistance)
        
        if let coords = activityTimer.coordinates() {
            let pline = MGLPolyline(coordinates: coords, count: UInt(coords.count))
            mapView.add(pline)
        }
        
        // Writing to Activity object will go here if updating continuously
        // or all coordinates at once in saveButtonPressed
//        let encoded = pline.geoJSONData(usingEncoding: String.Encoding.utf8.rawValue)
//        writePolylineToFile(encoded)
        
    }
    
    
}
