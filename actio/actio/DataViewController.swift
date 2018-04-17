//
//  DataViewController.swift
//  actio
//
//  Created by Alieta Train on 4/14/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

  @IBOutlet weak var emailLoginButton: UIButton!
  @IBOutlet weak var googleLoginButton: UIButton!
  @IBOutlet weak var facebookLoginButton: UIButton!
  @IBOutlet weak var dataLabel: UILabel!
  var dataObject: String = ""


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    facebookLoginButton.layer.cornerRadius = 4
    googleLoginButton.layer.cornerRadius = 4
    emailLoginButton.layer.cornerRadius = 4

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    self.dataLabel!.text = dataObject
  }


}

