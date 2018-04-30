//
//  ActivityCollectionViewController.swift
//  actio
//
//  Created by Alieta Train on 4/29/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import UIKit

class ActivityCollectionViewController: UIViewController {

  @IBOutlet weak var activityCollectionView: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    activityCollectionView.delegate = self
    activityCollectionView.dataSource = self as? UICollectionViewDataSource
  }
}
extension ActivityCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath)
    return cell
  }
}
