//
//  Activity.swift
//  actio
//
//  Contributors:
//    Alieta Train
//    Tyler Mcginnis on 5/5/18.
//    Jason Hoffman
//  Copyright © 2018 corvus group. All rights reserved.
//

import Foundation

protocol ActivityStorageAdapter {
    func save(activity: Activity)
    func update(activity: Activity)
    func delete(activity: Activity)
}
