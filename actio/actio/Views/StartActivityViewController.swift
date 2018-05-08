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
import Firebase

class StartActivityViewController: UIViewController {
    
    var activity: Activity!
    var ref: DatabaseReference!
    
    let locationManager = Loc.shared
    let activityTimer = ActivityTimer.shared
    let time = 0.0
    var paused = false
    
    @IBOutlet weak var activityNameField: UITextField!
    @IBOutlet weak var cancelToResumeButton: UIButton!
    @IBOutlet weak var recordActivityButton: UIButton!
    @IBOutlet weak var saveView: UIView!
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
        
        self.ref = Database.database().reference()
        
        // hide save and resume buttons
        saveButton.isHidden = true
        resumeButton.isHidden = true
        saveView.isHidden = true
        
        // MapBox setup again
        mapView.delegate = self
        mapView.compassView.isHidden = true
        mapView.attributionButton.isHidden = true
        mapView.logoView.isHidden = true
        mapView.showsUserLocation = true
        // Will receive notification from ActivityTimer
        NotificationCenter.default.addObserver(self, selector: #selector(updateTime(_:)), name: Notification.Name("Tick"), object: nil)
    }


    @IBAction func pauseButtonPressed(_ sender: Any) {
        // Pause/play animation should go here
        topDownMode()
        toggleButtons()
        activityTimer.pause()
        paused = !paused
    }
    
  @IBAction func saveButtonPressed(_ sender: Any) {
    // open view to add activity name for saving 
    saveView.isHidden = false
  }
  
  @IBAction func recordActivityPressed(_ sender: Any) {
    // perform saving functions here
    saveView.isHidden = false
    self.activity.name = activityNameField.text!
    var data: [String:Any] = [:]
    data["type"] = activity.type
    data["name"] = activity.name
    data["athlete"] = ["uid": activity.athlete.uid]
    data["start_date_local"] = activity.startDateLocal
    self.ref.child("activities").childByAutoId().setValue(data)
  }
  
  @IBAction func cancelRecordButtonPressed(_ sender: Any) {
    // perform saving functions here
    saveView.isHidden = true
  }
    
    @IBAction func resumeButtonPressed(_ sender: Any) {
        toggleButtons()
        courseMode()
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
         let courseCam =  MGLMapCamera(
                lookingAtCenter: mapView.userLocation!.coordinate, // possibly dangerous
                fromDistance: 400,
                pitch: 70.0,
                heading: mapView.camera.heading)
        mapView.fly(to: courseCam, completionHandler: nil)
    }
    
    func topDownMode() {
        mapView.userTrackingMode = .follow
        let topDownCam = MGLMapCamera(
                lookingAtCenter: mapView.userLocation!.coordinate,
                fromDistance: 1500,
                pitch: 0.0,
                heading: mapView.camera.heading)
        mapView.fly(to: topDownCam, completionHandler: nil)
    }
    
    func annotateStartEnd(coordinates: [CLLocationCoordinate2D]) {
        var annotations = [MGLPointAnnotation]()
        for c in coordinates {
            let p = MGLPointAnnotation()
            p.coordinate = c
            annotations.append(p)
        }
        mapView.addAnnotations(annotations)
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
        distanceLabel.text = String(format: "%.2f", activityTimer.totalDistance)
        if let locations = activityTimer.coordinates() {
            // Get coordinates
            let coords = locations.map { $0.coordinate }
            let pline = MGLPolyline(coordinates: coords, count: UInt(coords.count))
            mapView.add(pline)
        }
        
        // Writing to Activity object will go here if updating continuously
        // or all coordinates at once in saveButtonPressed
//        let encoded = pline.geoJSONData(usingEncoding: String.Encoding.utf8.rawValue)
//        writePolylineToFile(encoded)
        
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        courseMode()
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = MGLAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            
            annotationView?.backgroundColor = UIColor.red
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        if annotation.title == "recalled" {
            return UIColor.blue
        }
        
        return UIColor.orange
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return 5.0
    }
    
}
