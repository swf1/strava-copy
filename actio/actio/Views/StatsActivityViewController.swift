//
//  mainActivityViewController.swift
//  actio
//
//  Created by Alieta Train on 5/12/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit
import Firebase


class StatsActivityViewController: UIViewController {
  
    var activity: Activity!
    var ref: DatabaseReference!

    let locationManager = Loc.shared
    let activityTimer = ActivityTimer.shared

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels(_:)), name: Notification.Name("Tick"), object: nil)

    }
    
    @objc func updateLabels(_ notification: Notification) {
        if let t = notification.userInfo?["time"] as? String {
            DispatchQueue.main.async {
                self.elapsedTimeLabel.text = t
                self.paceLabel.text = self.activityTimer.pace()
                self.distanceLabel.text = String(format: "%.2f", self.activityTimer.totalDistance)
            }
        }
    }
}





