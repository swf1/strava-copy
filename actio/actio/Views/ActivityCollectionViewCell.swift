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
import FirebaseStorage

class ActivityCollectionViewCell: UICollectionViewCell {
  @IBOutlet var activityName: UILabel!
  @IBOutlet var activityType: UILabel!
  @IBOutlet var activityDistance: UILabel!
  @IBOutlet var activityPace: UILabel!
  @IBOutlet var activityDuration: UILabel!
  @IBOutlet var activityScreenshot: UIImageView!

  func displayContent(activity: Activity) {
    activityName.text = activity.name
    activityType.text = activity.type
    activityDistance.text = activity.distance
    activityPace.text = activity.pace
    activityDuration.text = activity.duration
    let ref = Storage.storage().reference();
    ref.child(activity.screenshotLabel!).getData(maxSize: 1 * 1024 * 1024) { data, error in
      if let error = error {
        print(error)
      } else {
        let image = UIImage(data: data!)
        self.activityScreenshot.image = image
      }
    }
  }
}
