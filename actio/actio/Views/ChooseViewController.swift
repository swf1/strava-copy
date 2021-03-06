//
//  ChooseViewController.swift
//  actio
//
//  Created by Alieta Train on 5/31/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit
import Firebase

class ChooseViewController: UIViewController {
  
  @IBOutlet weak var bikeBox: UIButton!
  @IBOutlet var chooseWrapper: UIView!
  var chooseViewActivityType: String!
  
  let locationManager = Loc.shared
  @IBOutlet weak var topBox: UIView!
  
  @IBOutlet weak var topLabel: UILabel!
  @IBOutlet weak var stackView: UIStackView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    chooseWrapper.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    topBox.roundCorners([.topLeft, .topRight], radius: 5)
    bikeBox.roundCorners([.bottomLeft, .bottomRight], radius: 5)

  }
  
  // override touches to dismiss choose view, don't dismiss if touch is on our
  // choose box
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch: UITouch? = touches.first
    if touch?.view != stackView && touch?.view != topBox && touch?.view != topLabel {
      dismiss(animated: true, completion: nil)
    }
  }

  @IBAction func dismissVC(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didPressRun() {
    self.chooseViewActivityType = "Run"
  }

  @IBAction func didPressBike() {
    self.chooseViewActivityType = "Bike"
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? InitialMapViewController
    {
      let formatter = DateFormatter()
      formatter.dateFormat = DateFormatter.dateFormat(
        fromTemplate: "MMddyyyy",
        options: 0,
        locale: Locale(identifier: "en-US")
      )
      vc.activity = Activity(
        type: chooseViewActivityType,
        startDateLocal: formatter.string(from: Date())
      )
      
      if let flag = locationManager.gpsFlag {
        flag.0 ? (vc.labelColor = UIColor.green) : (vc.labelColor = UIColor.red)
        vc.labelText = flag.1
      }
    }
  }
}


extension UIView {
  
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.frame = layer.bounds

    mask.path = path.cgPath
    self.layer.mask = mask
  }
  
}
