//
//  Activity.swift
//  actio
//
//  Contributors:
//    Alieta Train
//    Tyler Mcginnis on 4/29/18.
//    Jason Hoffman
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit
import Firebase

class SaveActivityViewController: UIViewController {
    var firebase: FirebaseAdapter!

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        firebase = FirebaseAdapter(model: "activities")
    }

    @IBAction func didSaveActivity(_ sender: UIButton) {
        guard let name = nameField.text else { return }
        guard let type = typeField.text else { return }
        guard let description = descriptionField.text else { return }

        nameField.text = ""
        typeField.text = ""
        descriptionField.text = ""

        view.endEditing(true)

        let data = [
            "name": name,
            "type": type,
            "description": description
        ]

        saveActivity(withData: data)
    }

    func saveActivity(withData data: [String: Any]) {
        var activityData = data

        guard let user = Auth.auth().currentUser else { return };
        activityData["athlete"] = ["uid": user.uid]

        let timestamp = NSDate().timeIntervalSince1970
        activityData["start_date_local"] = timestamp

        firebase.getRef().childByAutoId().setValue(activityData)
    }
}
