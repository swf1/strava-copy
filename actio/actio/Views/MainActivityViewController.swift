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
  var source: MGLShapeSource!
  
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

  }
  
  @objc func updateTime(_ notification: Notification) {
    if let t = notification.userInfo?["time"] as? String {
      // has to be on main thread
      DispatchQueue.main.async {
        self.elapsedTimeLabel.text = t
      }
    }
  }
  func showCompletedRoute() {
    if let c = activityTimer.coordinates() {
      let coordinates = c.map { $0.coordinate }
      let polyLine = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))
      polyLine.title = "recalled"
      mapView.add(polyLine)
      annotationsAt(coordinates: [coordinates.first!, coordinates.last!])
    }
  }
  
  func initPolyline() {
    guard let style = self.mapView.style else { return }
    
    // empty polyline to update as coordinate arrive
    let pline = MGLPolyline()
    source = MGLShapeSource(identifier: "activeRoute", shape: pline, options: nil)
    style.addSource(source)
    
    let layer = MGLLineStyleLayer(identifier: "activeRoute", source: source)
    
    layer.lineJoin = NSExpression(forConstantValue: "round")
    layer.lineCap = NSExpression(forConstantValue: "round")
    
    // color can be set here
    layer.lineColor = NSExpression(forConstantValue: UIColor.orange)
    layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                   [14: 2, 18: 20])
    
    style.addLayer(layer)
    //        style.addLayer(dashedLayer)
    //        style.insertLayer(casingLayer, below: layer)
  }
  
  func updatePolyline(coordinates: [CLLocationCoordinate2D]) {
    source.shape = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))
  }
  // polyline updates can take place in courseMode and topMode functions
  func courseMode() {
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
  
  func annotationsAt(coordinates: [CLLocationCoordinate2D]) {
    var annotations = [MGLPointAnnotation]()
    for c in coordinates {
      let p = MGLPointAnnotation()
      p.coordinate = c
      annotations.append(p)
    }
    
    mapView.addAnnotations(annotations)
  }
  
}

extension MainActivityViewController: MGLMapViewDelegate {
  
  func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
    if paused { return }
    paceLabel.text = activityTimer.pace()
    distanceLabel.text = String(format: "%.2f", activityTimer.totalDistance)
    if let locations = activityTimer.coordinates() {
      // Get coordinates
      let coords = locations.map { $0.coordinate }
      updatePolyline(coordinates: coords)
    }
    
    // Writing to Activity object will go here if updating continuously
    // or all coordinates at once in saveButtonPressed
    //        let encoded = pline.geoJSONData(usingEncoding: String.Encoding.utf8.rawValue)
    //        writePolylineToFile(encoded)
    
  }
  
  func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    print("didFinishLoading")
    initPolyline()
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
