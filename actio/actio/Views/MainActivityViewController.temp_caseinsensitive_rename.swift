//
//  mainActivityViewController.swift
//  actio
//
//  Created by Alieta Train on 5/12/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation


// MapBox setup again
mapView.delegate = self
mapView.compassView.isHidden = true
mapView.attributionButton.isHidden = true
mapView.logoView.isHidden = true
mapView.showsUserLocation = true
// Will receive notification from ActivityTimer
NotificationCenter.default.addObserver(self, selector: #selector(updateTime(_:)), name: Notification.Name("Tick"), object: nil)
