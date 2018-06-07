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
    var activityScreenshot: UIImage?
    let store = FirebaseDataStore.instance
    let locationManager = Loc.shared
    let activityTimer = ActivityTimer.shared
    var mapView: MGLMapView?
    
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cancelToResumeButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
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

    @IBAction func pauseButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "topDownMode"), object: nil)
        toggleButtons()
        activityTimer.pause()
        
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
//    NotificationCenter.default.post(name: Notification.Name("courseMode"), object: nil)
    let children = self.childViewControllers
    if let mv = children[0] as? MainActivityViewController {
        activityScreenshot = takeScreenshot(view: mv.mapView)
    }
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
        NotificationCenter.default.post(name: Notification.Name("courseMode"), object: nil)
        toggleButtons()
        activityTimer.startTime()
    }
    
    func toggleButtons() {
        pauseButton.isHidden = !pauseButton.isHidden
        saveButton.isHidden = !saveButton.isHidden
        resumeButton.isHidden = !resumeButton.isHidden
        mapToggleButton.isHidden = !mapToggleButton.isHidden
    }
    
    
    func takeScreenshot(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.bounds.size)
        if let _ = UIGraphicsGetCurrentContext() {
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
  
    // Hide status bar at top when modal seuges
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}



