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
    mapView.delegate = self as? MGLMapViewDelegate
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
}
