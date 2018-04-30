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

class InitialMapViewController: UIViewController {


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

    }

}

// MARK: MGLMapViewDelegate
extension InitialMapViewController: MGLMapViewDelegate {
    
}

// MARK: CLLocationManagerDelegate
extension InitialMapViewController: CLLocationManagerDelegate {
    
}
