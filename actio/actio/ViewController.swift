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
import FBSDKLoginKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        print("inside view did load")
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindtoWelcomeView(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
  @IBAction func facebookLogin(sender: UIButton) {
    let fbLoginManager = FBSDKLoginManager()
    fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
      if let error = error {
        print("Failed to login: \(error.localizedDescription)")
        return
      }
      
      guard let accessToken = FBSDKAccessToken.current() else {
        print("Failed to get access token")
        return
      }
      
      let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
      print("hello", accessToken, credential)
      
    }
  }
}

