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
  @IBOutlet var activityDuration: UILabel!

  func displayContent(activity: Activity) {
    activityName.text = activity.name
    activityType.text = activity.type
    activityDistance.text = activity.distance
    activityPace.text = activity.pace
    activityDuration.text = activity.duration
  }
}
