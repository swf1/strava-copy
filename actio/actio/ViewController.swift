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

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    print("logout")
  }
  func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    if ((error) != nil) {
      print("Error processing login button", error)
      // Process error
    }
    else if result.isCancelled {
      print("resuls is cancelled")
      // Handle cancellations
    }
    else {
      print("ready to navigate")
      // Navigate to other view
    }
  }

  @IBOutlet weak var loginButton: FBSDKLoginButton!

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
  override func viewDidLoad() {
    print("inside view did load")
    super.viewDidLoad()
  
    if (FBSDKAccessToken.current() != nil) {
      print("fbsdk is not empty: ", FBSDKAccessToken.current())
      // User is logged in, do work such as go to next view controller.
    }
    // Do any additional setup after loading the view, typically from a nib.
   let loginButton = FBSDKLoginButton()
    loginButton.delegate = self

   // let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
    loginButton.center = view.center
    view.addSubview(loginButton)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  


}

