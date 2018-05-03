//
//  StartActivityViewController.swift
//  actio
//
//  Created by Jason Hoffman on 5/1/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit

class StartActivityViewController: UIViewController {
    
    let locationManager = Loc.shared
    let activityTimer = ActivityTimer.shared
    let time = 0.0
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Will receive notification from ActivityTimer
        NotificationCenter.default.addObserver(self, selector: #selector(updateTime(_:)), name: Notification.Name("Tick"), object: nil)
    }

    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        // Pause/play animation should go here
        activityTimer.pause()
    }
    
    @objc func updateTime(_ notification: Notification) {
        if let t = notification.userInfo?["time"] as? String {
            // has to be on main thread
            DispatchQueue.main.async {
                self.elapsedTimeLabel.text = t
            }
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
