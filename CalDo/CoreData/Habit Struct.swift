//
//  Habit Struct.swift
//  CalDo
//
//  Created by Fabian Jaeger on 10/25/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import Foundation

let habitSections = ["Morning", "Evening", "All Day"]

struct habit{
    var habitTitle: String?
    var habitComplete: Bool
    var todoPicture: String
    var habitSection: Int?
    var habitTime: Date?
//    var todoReminder:
    static func loadHabits() -> [habit]? {
        return nil
    }

    
    static func loadSampleHabits() -> [habit] {
        let habit1 = habit(habitTitle: "Read", habitComplete: false, todoPicture: "Test", habitSection: 1, habitTime: nil)
        return [habit1]
    }
}
