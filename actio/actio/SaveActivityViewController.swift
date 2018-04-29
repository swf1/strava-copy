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

    @IBAction func didPressSave(_ sender: UIButton) {
        if let inputs = collectInputs() {
            nameField.text = ""
            typeField.text = ""
            descriptionField.text = ""

            view.endEditing(true)

            guard let user = Auth.auth().currentUser else { return };
            let activity = Activity(
                athlete: Athlete(uid: user.uid),
                name: inputs["name"]!,
                type: inputs["type"]!,
                startDateLocal: String(NSDate().timeIntervalSince1970),
                description: inputs["description"]!
            )
            activity.save(withConnection: firebase)
        }
    }

    func collectInputs() -> [String:String]? {
        guard let name = nameField.text else { return nil }
        guard let type = typeField.text else { return nil }
        guard let description = descriptionField.text else { return nil }

        return [
            "name": name,
            "type": type,
            "description": description
        ]
    }
}
