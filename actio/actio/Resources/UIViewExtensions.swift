//
//  VCAnimations.swift
//  actio
//
//  Created by Alieta Train on 6/2/18.
//  Copyright © 2018 corvus group. All rights reserved.
//  from other views can call self.view.fadeIn();

import Foundation
import UIKit

extension UIView {
  func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
    UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
      self.alpha = 1.0
    }, completion: completion)  }
  
  func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
    UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
      self.alpha = 0.0
    }, completion: completion)
  }
}
