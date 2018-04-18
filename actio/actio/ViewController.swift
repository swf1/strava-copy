//
//  ViewController.swift
//  actio
//
//  Contributors:
//    Alieta Train on 4/17/18.
//    Tyler Mcginnis
//    Jason Hoffman
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit
import FacebookLogin
import Firebase
import FBSDKLoginKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
   // let loginButton = FBSDKLoginButton()
   // loginButton.delegate = self
    let loginButton = LoginButton(readPermissions: [ .publicProfile ])
    loginButton.center = view.center
    
    view.addSubview(loginButton)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

