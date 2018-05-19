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
    
    var activity: Activity!
    let locationManager = Loc.shared
    let activityTimer = ActivityTimer.shared
    let time = 0.0
    var paused = false
    var purpleSource: MGLShapeSource!
    var purpleLayer: MGLStyleLayer!
    var greenSource: MGLShapeSource!
    var greenLayer: MGLStyleLayer!
    
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var cancelToResumeButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MGLMapView!
    
  @IBOutlet weak var resumeButton: UIButton!
  @IBOutlet weak var mapToggleButton: UIButton!
  
  @IBOutlet weak var pauseButton: UIButton!
  @IBOutlet weak var saveButton: UIButton!
  


    override func viewDidLoad() {
        super.viewDidLoad()

        // hide save and resume buttons
        saveButton.isHidden = true
        resumeButton.isHidden = true
        cancelToResumeButton.isHidden = true

    }

    var delegate: mainActivityViewProtocol?
  
    @IBAction func pauseButtonPressed(_ sender: Any) {
        // Pause/play animation should go here
        self.delegate?.topDownMode()
        toggleButtons()
        activityTimer.pause()
        paused = !paused
    }

  @IBAction func showStatsView(sender: UIButton) {
    if (self.statsView.alpha == 0) {
      UIView.animate(withDuration: 0.5, animations: {
        self.statsView.alpha = 1
        self.mainView.alpha = 0
        self.saveView.alpha = 0
      })
    } else {
      UIView.animate(withDuration: 0.5, animations: {
        self.statsView.alpha = 0
        self.mainView.alpha = 1
        self.saveView.alpha = 0
      })
    }
  }
  
  @IBAction func showSaveView(sender: UIButton) {
    if (self.saveView.alpha == 0) {
      UIView.animate(withDuration: 0.5, animations: {
        self.saveView.alpha = 1
        self.mainView.alpha = 0
        self.statsView.alpha = 0
      })
    }
  }
    
  @IBAction func saveButtonPressed(_ sender: Any) {
    // open view to add activity name for saving 
    cancelToResumeButton.isHidden = false
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? SaveActivityViewController
    {
      vc.activity = self.activity
    }
  }
  
  
  @IBAction func cancelRecordButtonPressed(_ sender: Any) {
    cancelToResumeButton.isHidden = true
    // perform saving functions here
    if (self.saveView.alpha == 1) {
      UIView.animate(withDuration: 0.5, animations: {
        self.saveView.alpha = 0
        self.mainView.alpha = 1
        self.statsView.alpha = 0
      })
    }
  }
    
    @IBAction func resumeButtonPressed(_ sender: Any) {
        toggleButtons()
        self.delegate?.courseMode()
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
        self.delegate?.courseMode()
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

