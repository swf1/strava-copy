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
import FBSDKLoginKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import FacebookLogin

class ViewController: UIViewController {
    override func viewDidLoad() {
        print("inside view did load")
        super.viewDidLoad()
        self.title = ""

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
      print("access token", accessToken)
      print("access token string", accessToken.tokenString)
      
      let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)

        // Perform login by calling Firebase APIs
        Auth.auth().signIn(with: credential, completion:
            
         { (user, error) in
            if let error = error {
                let castedError = error as NSError
                //let firebaseError = AuthErrorCode(rawValue: castedError.code)
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: castedError.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            // Present the main view
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        })
      print("hello", credential)
      
    }
  }
}

