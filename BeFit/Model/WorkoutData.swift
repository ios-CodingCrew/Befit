//
//  WorkoutData.swift
//  BeFit
//
//  Created by Evelyn on 4/11/23.
//

import Foundation


struct WorkoutData {
    var userid: Int?
    var workout_id: Int?
    var workout_date: Date?
    var workout_type: String?
    var duration: Int? //dutation is expected in mins, so int should be fine
    
    //var workoutCount: Int
}
