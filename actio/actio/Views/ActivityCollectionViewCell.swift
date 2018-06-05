//
//  Activity.swift
//  actio
//
//  Contributors:
//    Alieta Train
//    Tyler Mcginnis
//    Jason Hoffman
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {
  @IBOutlet var activityName: UILabel!
  @IBOutlet var activityType: UILabel!
  @IBOutlet var activityDistance: UILabel!
  @IBOutlet var activityPace: UILabel!

  func displayContent(name: String, type: String, distance: String, pace: String) {
    activityName.text = name
    activityType.text = type
    activityDistance.text = distance
    activityPace.text = pace
  }
}
