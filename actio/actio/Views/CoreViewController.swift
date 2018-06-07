//
//  ActivityCollectionViewController.swift
//  actio
//
//  Created by Alieta Train on 4/29/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import UIKit
import Firebase

// container collection container view
// and profile container view
class CoreViewController: UIViewController {
  
  @IBOutlet weak var titleBar: UINavigationItem!
  @IBOutlet weak var activityCollectionView: UICollectionView!
  
  // containers
  @IBOutlet weak var manualAddContainerView: UIView!
  @IBOutlet weak var activityCollectionContainerView: UIView!
  @IBOutlet weak var profileContainerView: UIView!
  
 // @IBOutlet weak var chooseView: UIView!
  @IBOutlet weak var manualAddButton: UIBarButtonItem!
  @IBOutlet weak var profileButton: UIBarButtonItem!
  @IBOutlet weak var homeButton: UIBarButtonItem!
  @IBOutlet weak var goToTrackRun: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.titleBar.title = "Welcome"
  }
  
  @IBAction func unwindToCoreView(segue: UIStoryboardSegue){}

  @IBAction func showProfileView(sender: UIBarButtonItem) {
    self.titleBar.title = "Your profile"
    if (self.profileContainerView.alpha == 0) {
      UIView.animate(withDuration: 0.5, animations: {
        self.profileContainerView.alpha = 1
        self.manualAddContainerView.alpha = 0
        self.activityCollectionContainerView.alpha = 0
      })
    }
  }
  
  @IBAction func showManualAddView(sender: UIBarButtonItem) {
    self.titleBar.title = "Manually add activity"
    if (self.manualAddContainerView.alpha == 0) {
      UIView.animate(withDuration: 0.5, animations: {
        self.profileContainerView.alpha = 0
        self.manualAddContainerView.alpha = 1
        self.activityCollectionContainerView.alpha = 0
      })
    }
  }
  
  @IBAction func showActivityCollectionView(sender: UIBarButtonItem) {
    self.titleBar.title = "Your activities"
    if (self.activityCollectionContainerView.alpha == 0) {
      UIView.animate(withDuration: 0.5, animations: {
        self.profileContainerView.alpha = 0
        self.manualAddContainerView.alpha = 0
        self.activityCollectionContainerView.alpha = 1
      })
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? ProfileViewController
    {
      guard let user = Auth.auth().currentUser else { return }
      vc.name = user.displayName
      vc.photo = user.photoURL
    }
  }
}


