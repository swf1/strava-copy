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

  func displayContent(name: String, type: String) {
    activityName.text = name
    activityType.text = type
  }
}
