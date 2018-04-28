//
//  FirebaseAdapter.swift
//  actio
//
//  Contributors:
//    Alieta Train
//    Tyler Mcginnis on 4/28/18.
//    Jason Hoffman
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAdapter {
    var model: String
    var ref: DatabaseReference!

    init(model: String) {
        self.model = model
        ref = Database.database().reference()
    }

    func getRef() -> DatabaseReference {
        return self.ref.child(model)
    }
}
