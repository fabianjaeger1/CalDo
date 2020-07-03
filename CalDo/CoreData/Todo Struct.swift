//
//  Todo Struct.swift
//  CalDo
//
//  Created by Fabian Jaeger on 04.08.18.
//  Copyright © 2018 CalDo. All rights reserved.
//

import Foundation
import UIKit

import CoreData
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
        let todo6 = TodoItem(todoTitle: "Fuck my Life", todoCompleted: false, todoDate: Date(), todoNotes: nil, todoTags: [], todoPriority: [2], todoProject: Project2, todoLocation: nil, todoRecurrence: false)
        let todo7 = TodoItem(todoTitle: "Smash  Nathan", todoCompleted: false, todoDate: Date(), todoNotes: nil, todoTags: [], todoPriority: [2], todoProject: Project2, todoLocation: nil, todoRecurrence: false)
        
        return [todo1,todo2,todo3,todo4,todo5,todo6,todo7]
    }
    
}

// Load (& save) sample CoreData tasks
func loadSampleTaskEntities() {
    // let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let managedContext = CoreDataManager.shared.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

    do {
        try managedContext.execute(batchDeleteRequest)
        // try managedContext.save()
    } catch {
        print("Error batch deleting \(error)")
    }
    
    
    
    
    let project1 = ProjectEntity(context: managedContext)
    project1.title = "Personal"
    project1.color = "98D468"
    
    let project2 = ProjectEntity(context: managedContext)
    project2.title = "Work"
    project2.color = "4FC2E8"
    
    
    let tag1 = TagEntity(context: managedContext)
    tag1.title = "Calls"
    tag1.color = "98D468"
    
    let tag2 = TagEntity(context: managedContext)
    tag2.title = "Mom"
    tag2.color = "4FC2E8"
    
    
    let task1 = TaskEntity(context: managedContext)
    task1.title = "Call Mom"
    task1.priority = 2
    task1.project = project1
    task1.tags = [tag1, tag2]
    
    let task2 = TaskEntity(context: managedContext)
    task2.title = "Do Taxes"
    task2.priority = 1
    task2.project = project2
    task2.tags = [tag1]
    
    let task3 = TaskEntity(context: managedContext)
    task3.title = "Go Shopping"
    task3.project = project1
    task3.tags = [tag2]
    
    let task4 = TaskEntity(context: managedContext)
    task4.title = "Plan Holidays"
    task4.priority = 1
    task4.project = project2
    
    // task4.tags = [TagEntity]()
    
    let task5 = TaskEntity(context: managedContext)
    task5.title = "Go Bonkers!!!"
    task5.project = project1
    task5.tags = [tag1, tag2]
    
    let task6 = TaskEntity(context:managedContext)
    task6.title = "Feed dogs"
    task6.tags = [tag1]
    
    let task7 = TaskEntity(context: managedContext)
    task7.title = "Go to dentist with mom"
    task7.tags = [tag2]
    
    do {
        try managedContext.save()
    } catch {
        print("Error saving data to context \(error)")
    }
    
    // return [task1, task2, task3, task4, task5]
}

