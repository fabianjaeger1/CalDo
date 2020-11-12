//
//  CoreDataManager.swift
//  CalDo
//
//  Created by Nathan Baudis  on 7/2/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "CoreDataModel")
         container.loadPersistentStores(completionHandler: { (storeDescription, error) in
             if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         })
        container.viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
         return container
     }()
    
    func saveContext () {
        let managedContext = persistentContainer.viewContext
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error saving data to context \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: - Task arrays & methods
    
    var allTasks = [TaskEntity]()

    var inboxTasks = [TaskEntity]()
    
    var upcomingTasks = [TaskEntity]()
    
    var todayTasks = [TaskEntity]()
    
    // TODO: add separate class for functions that don't depend on the CoreData context/container?
    // TODO: add functions for sorting by descending date/title or ascending priority?
    
    // Call: sortTasksByDate(&allTasks)
    
    // Sort by ascending date
    func sortTasksByDate(tasks: inout [TaskEntity]) {
        if !tasks.isEmpty {
            tasks.sort {
                ($0.value(forKey: "date") as! Date).compare($1.value(forKey: "date") as! Date) == .orderedAscending
            }
            var i = 0
            for task in tasks {
                task.setValue(i, forKey: "sortOrder")
                i += 1
            }
            self.saveContext()
        }
    }
    
    // Sort by ascending title
    func sortTasksByTitle(tasks: inout [TaskEntity]) {
        if !tasks.isEmpty {
            tasks.sort {
                ($0.value(forKey: "title") as! String) < ($1.value(forKey: "title") as! String)
            }
            var i = 0
            for task in tasks {
                task.setValue(i, forKey: "sortOrder")
                i += 1
            }
            self.saveContext()
        }
    }
    
    // Sort by descending priority
    func sortTasksByPriority(tasks: inout [TaskEntity]) {
        if !tasks.isEmpty {
            tasks.sort {
                ($0.value(forKey: "priority") as! Int) > ($1.value(forKey: "priority") as! Int)
            }
            var i = 0
            for task in tasks {
                task.setValue(i, forKey: "sortOrder")
                i += 1
            }
            self.saveContext()
        }
    }
        
    
    // MARK: - Fetching, adding, deleting tasks
    
    // TODO: optional return value? what happens when there are no tasks?
    func fetchAllTasks() {
        let managedContext = persistentContainer.viewContext
        
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let predicate = NSPredicate(format: "(completed == false)")
        request.predicate = predicate
        
        do {
            self.allTasks = try managedContext.fetch(request)
        } catch {
            print("Error fetching tasks from context \(error)")
        }
    }
    
    func fetchInboxTasks() {
        let managedContext = persistentContainer.viewContext
        
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let predicate = NSPredicate(format: "(completed == false) AND (project == nil)")
        request.predicate = predicate
        
        do {
            self.inboxTasks = try managedContext.fetch(request)
        } catch {
            print("Error fetching inbox tasks from context \(error)")
        }
    }
    
    // TODO: sort them by default? Could interfere with custom sorting order -> how to deal with this? could add an attribute to the entity giving the sort order
    
    // Fetches the upcoming tasks into the upcomingTasks variable, sorted by date
    func fetchUpcomingTasks() {
        let managedContext = persistentContainer.viewContext
               
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let predicate = NSPredicate(format: "(completed == false) AND (date != nil)")
        request.predicate = predicate
        
        do {
            self.upcomingTasks = try managedContext.fetch(request)
        } catch {
            print("Error fetching upcoming tasks from context \(error)")
        }
        
        if !self.upcomingTasks.isEmpty {
            self.upcomingTasks.sort {
                ($0.value(forKey: "date") as! Date).compare($1.value(forKey: "date") as! Date) == .orderedAscending
            }
        }
    }
    
    // Fetches the today tasks into the todayTasks variable, sorted by date
    func fetchTodayTasks() {
        let managedContext = persistentContainer.viewContext
                 
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        var dateTo = calendar.startOfDay(for: Date())
        dateTo = calendar.date(byAdding: .day, value: 1, to: dateTo)!
        
        let predicate = NSPredicate(format: "(completed == false) AND (date <= %@)", dateTo as NSDate)
          request.predicate = predicate
          
        do {
            self.todayTasks = try managedContext.fetch(request)
        } catch {
            print("Error fetching today tasks from context \(error)")
        }
        
        if !self.todayTasks.isEmpty {
            self.todayTasks.sort {
                ($0.value(forKey: "date") as! Date).compare($1.value(forKey: "date") as! Date) == .orderedAscending
            }
        }
    }
    
    func addTask(title: String, tags: NSSet) {
        let managedContext = persistentContainer.viewContext
        
        
    }
    
    func deleteTask(_ task: TaskEntity) {
        let managedContext = persistentContainer.viewContext
        
        managedContext.delete(task)
        
        do {
            try managedContext.save()
        } catch let saveError {
            print("Failed to delete task: \(saveError)")
        }
        
    }
    
    func setTaskPriority(task: TaskEntity, priority: Int) {
        
        if (priority < 0 || priority > 2) {
            return
        }
        
        let managedContext = persistentContainer.viewContext
        task.setValue(priority, forKey: "priority")
        
        do {
            try managedContext.save()
        } catch let saveError {
            print("Failed to set task priority: \(saveError)")
        }
        
        
    }
    
    
    // MARK: - Projects
    
    var projects = [ProjectEntity]()
    
    func sortProjectsByTitle() {
        if !self.projects.isEmpty {
            self.projects.sort {
                ($0.value(forKey: "title") as! String) < ($1.value(forKey: "title") as! String)
            }
        }
    }
    
    func fetchProjects() {
        let managedContext = persistentContainer.viewContext
        
        let request : NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        
        do {
            self.projects = try managedContext.fetch(request)
        } catch {
            print("Error fetching projects from context \(error)")
        }
    }
    
    func fetchProjectFromTask(task: TaskEntity) -> ProjectEntity? {
        let project = task.value(forKey: "project") as? ProjectEntity
        return project
    }
    
    func projectColor(project: ProjectEntity) -> UIColor? {
        if let colorString = project.value(forKey: "color") as? String {
            return UIColor(hexString: colorString)
        } else {
            return nil
        }
    }
    
    func deleteProject(_ project: ProjectEntity) {
        let managedContext = persistentContainer.viewContext
        
        // Delete all associated tasks as well
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = TaskEntity.fetchRequest()
        let predicate = NSPredicate(format: "(completed == false) AND (project == %@)", project)
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print("Failed to delete tasks from context \(error)")
            return
        }
        
        do {
            managedContext.delete(project)
            try managedContext.save()
        } catch let saveError {
            print("Failed to delete project: \(saveError)")
        }
        
    }
    
    
    // MARK: - Tags
    
    func fetchSortedTags() -> [TagEntity] {
        let managedContext = persistentContainer.viewContext
        
        var tags = [TagEntity]()
        
        let request : NSFetchRequest<TagEntity> = TagEntity.fetchRequest()
        do {
           tags = try managedContext.fetch(request)
        } catch {
            print("Error fetching tags from context \(error)")
        }
        
        if !tags.isEmpty {
            tags.sort {
                ($0.value(forKey: "title") as! String) < ($1.value(forKey: "title") as! String)
            }
        }
        return tags
    }
    
    func fetchSortedTagsFromTask(task: TaskEntity) -> [TagEntity] {
        let taskTagsSet = task.value(forKey: "tags") as! Set<TagEntity>
        var taskTags = Array(taskTagsSet)
        
        if !taskTags.isEmpty {taskTags.sort { ($0.value(forKey: "title") as! String) < ($1.value(forKey: "title") as! String)
            }
        }
        return taskTags
    }
    
    func deleteTag(_ tag: TagEntity) {
        let managedContext = persistentContainer.viewContext
        
        managedContext.delete(tag)
        
        do {
            try managedContext.save()
        } catch let saveError {
            print("Failed to delete tag: \(saveError)")
        }
        
    }
    
    
}



