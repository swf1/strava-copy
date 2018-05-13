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


class StatsActivityViewController: UIViewController {
  
  var activity: Activity!
  var ref: DatabaseReference!
  
  let locationManager = Loc.shared
  let activityTimer = ActivityTimer.shared
  let time = 0.0
  var paused = false
  var source: MGLShapeSource!
  
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!  
  @IBOutlet weak var elapsedTimeLabel: UILabel!
}

