//
//  FirebaseAdapter.swift
//  actio
//
//  Created by Tyler McGinnis on 4/26/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAdapter {
    var ref: DatabaseReference!
    fileprivate var _refHandle: DatabaseHandle!

    init(childAddedHandler: @escaping (DataSnapshot) -> Void) {
        ref = Database.database().reference()
        _refHandle = self.ref.child("activities").observe(.childAdded, with: childAddedHandler)
    }

    deinit {
        if _refHandle != nil {
            self.ref.child("activities").removeObserver(withHandle: _refHandle)
        }
    }
}
