//
//  Todo Struct.swift
//  CalDo
//
//  Created by Fabian Jaeger on 04.08.18.
//  Copyright © 2018 CalDo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

let latitude: CLLocationDegrees = 37.2
let longitude: CLLocationDegrees = 22.9

let location: CLLocation = CLLocation(latitude: latitude,
longitude: longitude)

func createDate() -> Date{
    var dateComponents = DateComponents()
    dateComponents.year = 2020
    dateComponents.month = 7
    dateComponents.day = 4
    dateComponents.hour = 8
    dateComponents.minute = 34

    // Create date from components
    let userCalendar = Calendar.current // user calendar
    let someDateTime = userCalendar.date(from: dateComponents)
    return someDateTime!
}

func createDate2() -> Date{
    var dateComponents = DateComponents()
     dateComponents.year = 2020
     dateComponents.month = 7
     dateComponents.day = 12
     dateComponents.hour = 8
     dateComponents.minute = 34

     // Create date from components
     let userCalendar = Calendar.current // user calendar
     let someDateTime = userCalendar.date(from: dateComponents)
     return someDateTime!
}


let now = Calendar.current.dateComponents(in: .current, from: Date())
let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
let dateTomorrow = Calendar.current.date(from: tomorrow)!

struct TodoItem {
    var todoTitle: String?
    var todoCompleted: Bool
    var todoDate: Date?
    var todoNotes: String?
    var todoTags: [tag]?
    var todoPriority = [0,1,2] // 3 priority levels
//    var todoReminder:
    var todoProject: Project?
    var todoLocation: NSObject?
    var todoRecurrence: Bool
    static func loadToDos() -> [TodoItem]? {
        return nil
    }
    

//INBOX DATA TYPE
// If Project != nil
    
    

    static func loadSampleToDos() -> [TodoItem] {
        let TagColors = ["98D468","ED5465","82DAE0","4FC2E8","B0E5CA", "F5BA41"]
        let Project1 = Project(ProjectTitle: "Personal", ProjectColor: "98D468")
        let Project2 = Project(ProjectTitle: "Work", ProjectColor: "4FC2E8")
        let tag1 = tag(tagLabel: "Call", tagColor: UIColor(hexString: "98D468") )
        let tag2 = tag(tagLabel: "Mom", tagColor: UIColor(hexString: "4FC2E8"))
        let tag3 = tag(tagLabel: "Test", tagColor: UIColor(hexString: "4FC2E8"))
        
        let todo1 = TodoItem(todoTitle: "Call Mom", todoCompleted: false, todoDate: createDate(), todoNotes: nil, todoTags: [tag1,tag2], todoPriority: [3], todoProject: Project1, todoLocation: location, todoRecurrence: false)
        let todo2 = TodoItem(todoTitle: "Do Taxes", todoCompleted: false, todoDate: dateTomorrow, todoNotes: "Notes 2", todoTags: [tag1, tag2], todoPriority: [2], todoProject: Project2, todoLocation: nil, todoRecurrence: true)
        let todo3 = TodoItem(todoTitle: "Go Shopping", todoCompleted: false, todoDate: Date(), todoNotes: nil , todoTags: [tag1,tag2], todoPriority: [1], todoProject: Project1, todoLocation: nil, todoRecurrence: false)
        let todo4 = TodoItem(todoTitle: "Plan Holidays", todoCompleted: false, todoDate: Date(), todoNotes: "Notes", todoTags: [tag2,tag1,tag3], todoPriority: [2], todoProject: Project2, todoLocation: nil, todoRecurrence: false)
        let todo5 = TodoItem(todoTitle: "Go Bonkers", todoCompleted: false, todoDate: createDate2(), todoNotes: nil, todoTags: [], todoPriority: [1], todoProject: Project1, todoLocation: nil, todoRecurrence: false)
        
        return [todo1,todo2,todo3,todo4,todo5]
    }
    
}
