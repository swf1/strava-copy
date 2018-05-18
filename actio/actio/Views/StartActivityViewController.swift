//
//  StartActivityViewController.swift
//  actio
// demo folder
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
    var purpleSource: MGLShapeSource!
    var purpleLayer: MGLStyleLayer!
    var greenSource: MGLShapeSource!
    var greenLayer: MGLStyleLayer!
    
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
        mapView.isUserInteractionEnabled = false // maybe this goes away later
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
        var coordinates: [[String:Double]] = []
        for l in activityTimer.coordinates()! {
            coordinates.append([
                "latitude": l.coordinate.latitude,
                "longitude": l.coordinate.longitude
                ])
        }
        data["route"] = ["coordinates": coordinates]
        self.ref.child("activities").childByAutoId().setValue(data)
    }
    
    @IBAction func cancelRecordButtonPressed(_ sender: Any) {
        // perform saving functions here
        saveView.isHidden = true
    }
    
    @IBAction func resumeButtonPressed(_ sender: Any) {
        toggleButtons()
        courseMode()
    }
    
    @objc func updateTime(_ notification: Notification) {
        if let t = notification.userInfo?["time"] as? String {
            // has to be on main thread
            DispatchQueue.main.async {
                self.elapsedTimeLabel.text = t
            }
        }
    }
    
    func initGreenLine() {
        guard let style = self.mapView.style else { return }
        let greenLine = MGLPolyline()
        greenSource = MGLShapeSource(identifier: "greenLine", shape: greenLine, options: nil)
        style.addSource(greenSource)
        let layer = MGLLineStyleLayer(identifier: "greenLine", source: greenSource)
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        let green = UIColor(red: 0/255.0, green: 201/255.0, blue: 132/255.0, alpha: 1.0)
        layer.lineColor = NSExpression(forConstantValue: green)
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 2, 18: 20])
        greenLayer = layer
        style.addLayer(greenLayer)
        //        annotationsAt(coordinates: [coordinates.first!, coordinates.last!])
    }
    
    func initPurpLine() {
        guard let style = self.mapView.style else { return }
        let pline = MGLPolyline()
        purpleSource = MGLShapeSource(identifier: "purpleLine", shape: pline, options: nil)
        style.addSource(purpleSource)
        let layer = MGLLineStyleLayer(identifier: "purpleLine", source: purpleSource)
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        // color can be set here
        let purp = UIColor(red: 175/255.0, green: 0/255.0, blue: 214/255.0, alpha: 1.0)
        layer.lineColor = NSExpression(forConstantValue: purp)
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 2, 18: 20])
        purpleLayer = layer
        style.addLayer(layer)
    }
    
    func updatePurpleLine(coordinates: [CLLocationCoordinate2D]) {
        purpleSource.shape = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))
    }
    
    func toggleButtons() {
        // this should become an animation
        pauseButton.isHidden = !pauseButton.isHidden
        saveButton.isHidden = !saveButton.isHidden
        resumeButton.isHidden = !resumeButton.isHidden
        mapToggleButton.isHidden = !mapToggleButton.isHidden
    }
    
    // polyline updates can take place in courseMode and topMode functions
    func courseMode() {
        purpleLayer.isVisible = true
        greenLayer.isVisible = false
        removeAnnotations()
        let courseCam =  MGLMapCamera(
            lookingAtCenter: mapView.userLocation!.coordinate, // possibly dangerous
            fromDistance: 400,
            pitch: 70.0,
            heading: mapView.camera.heading)
        mapView.fly(to: courseCam) {
            self.mapView.setUserTrackingMode(.followWithCourse, animated: true)
        }
    }
    
    func topDownMode() {
        purpleLayer.isVisible = false
        greenSource.shape = purpleSource.shape
        greenLayer.isVisible = true // green line only updates on pause so doesn't keep extending
        mapView.userTrackingMode = .follow
        let topDownCam = MGLMapCamera(
            lookingAtCenter: mapView.userLocation!.coordinate,
            fromDistance: 1500,
            pitch: 0.0,
            heading: mapView.camera.heading)
        mapView.fly(to: topDownCam, completionHandler: nil)
        
        if let c = activityTimer.coordinates() {
            annotationsAt(coordinates: [c.first!.coordinate, c.last!.coordinate])
        }
        
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
    
    func annotationsAt(coordinates: [CLLocationCoordinate2D]) {
        var annotations = [MGLPointAnnotation]()
        for c in coordinates {
            let p = MGLPointAnnotation()
            p.coordinate = c
            annotations.append(p)
        }
        mapView.addAnnotations(annotations)
    }
    
    func removeAnnotations() {
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
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

extension StartActivityViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        if paused { return }
        paceLabel.text = activityTimer.pace()
        distanceLabel.text = String(format: "%.2f", activityTimer.totalDistance)
        if let locations = activityTimer.coordinates() {
            // Get coordinates
            let coords = locations.map { $0.coordinate }
            updatePurpleLine(coordinates: coords)
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        initPurpLine()
        initGreenLine()
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
}
