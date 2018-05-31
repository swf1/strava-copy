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
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import FacebookLogin
import GoogleSignIn

import UIKit

class ViewController: UIViewController, GIDSignInUIDelegate {
 
  @IBOutlet weak var googleLogin: UIButton!
  @IBOutlet weak var emailLogin: UIButton!
  @IBOutlet weak var facebookButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    emailLogin.layer.borderWidth = 0.5
    googleLogin.layer.borderWidth = 0.5
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindtoWelcomeView(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
  
    // our button triggers this
    @IBAction func googleLogin(sender:UIButton) {
      GIDSignIn.sharedInstance().uiDelegate = self
      GIDSignIn.sharedInstance().signIn()
      
    }
  

  @IBAction func  googleLogout (sender:UIButton) {
      func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
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

