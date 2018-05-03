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
    
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        
    }
    // Hide status bar at top when modal seuges
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

}
