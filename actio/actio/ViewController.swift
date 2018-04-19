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
import FBSDKCoreKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate  {
    
  func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    if let error = error {
      print(error.localizedDescription)
      return
    }
    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
    Auth.auth().signIn(with: credential) {
      (user, error) in
      if let error = error {
        print(error)
        return
      }
      // User is signed in
      // ...
    }
  }
  
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    //
  }
  
  func loginButtonWillLogin(_ loginButton: FBSDKLoginButton) -> Bool{
    return true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  
    // Do any additional setup after loading the view, typically from a nib.
  
    //let loginButton = LoginButton(readPermissions: [ .publicProfile ])
    //loginButton.center = view.center
    
    let loginButton = FBSDKLoginButton()
    loginButton.delegate = self
    loginButton.center = view.center
    view.addSubview(loginButton)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

