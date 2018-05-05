//
//  Athlete.swift
//  actio
//
//  Created by Tyler McGinnis on 5/5/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation

class Athlete: NSObject {
    var uid: String
    var email: String

    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
