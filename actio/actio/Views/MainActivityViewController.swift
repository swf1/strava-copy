
//
//  mainActivityViewController.swift
//  actio
//
//  Created by Alieta Train on 5/12/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox
import Firebase


class MainActivityViewController: UIViewController {

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
  
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.ref = Database.database().reference()

    // MapBox setup again
    mapView.delegate = self
    mapView.compassView.isHidden = true
    mapView.attributionButton.isHidden = true
    mapView.logoView.isHidden = true
    mapView.showsUserLocation = true
    // Will receive notification from ActivityTimer
    NotificationCenter.default.addObserver(self, selector: #selector(updateTime(_:)), name: Notification.Name("Tick"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(topDownMode(_:)), name: Notification.Name("topDownMode"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(courseMode(_:)), name: Notification.Name("courseMode"), object: nil)
  }
  
    @objc func updateTime(_ notification: Notification) {
        if paused { return }
        if let t = notification.userInfo?["time"] as? String {
            DispatchQueue.main.async {
                self.elapsedTimeLabel.text = t
            }
        }
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
    }
    
    // polyline updates can take place in courseMode and topMode functions
    @objc func courseMode(_ notification: Notification?) {
        paused = false
        purpleLayer.isVisible = true
        greenLayer.isVisible = false
        mapView.isUserInteractionEnabled = false
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

    @objc func topDownMode(_ notification: Notification) {
        paused = true
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
  
    func annotationsAt(coordinates: [CLLocationCoordinate2D]) {
        var first = true
        for c in coordinates {
            let p = MGLPointAnnotation()
            p.title = (first ? "first" : "second")
            first = false
            p.coordinate = c
            mapView.addAnnotation(p)
        }
    }
    
    func removeAnnotations() {
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
    }
}

extension MainActivityViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        if !paused {
            paceLabel.text = activityTimer.pace()
            distanceLabel.text = String(format: "%.2f", activityTimer.totalDistance)
        }

        if let locations = activityTimer.coordinates() {
            let coords = locations.map { $0.coordinate }
            updatePurpleLine(coordinates: coords)
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        initPurpLine()
        initGreenLine()
        courseMode(nil)
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        let annotationView = RouteAnnotation()
        annotationView.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        annotationView.backgroundColor = (annotationView.annotation?.title == "first" ? UIColor.green : UIColor.red)
        return annotationView
    }
}
