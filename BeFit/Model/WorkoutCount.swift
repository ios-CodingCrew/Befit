//
//  WorkoutCount.swift
//  BeFit
//
//  Created by Evelyn on 4/25/23.
//


import Foundation
import ParseSwift

struct WorkoutCount: ParseObject {
    var originalData: Data?
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var userid: Int?
    var workout_date: Date?
    var checkin_count: Int?
}
