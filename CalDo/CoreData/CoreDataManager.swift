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
    
    // MARK: - Fetching, adding, deleting tasks
    
    // TODO: optional return value? what happens when there are no tasks?
    func fetchAllTasks(){
        let managedContext = persistentContainer.viewContext
        
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
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
    
    func addTask(title: String, tags: NSSet) {
        let managedContext = persistentContainer.viewContext
        
        
    }
    
    func deleteTask(task: TaskEntity) {
        let managedContext = persistentContainer.viewContext
        
        managedContext.delete(task)
        
        do {
            try managedContext.save()
        } catch let saveError {
            print("Failed to delete task: \(saveError)")
        }
        
        
    }
    
    
    // MARK: - Projects
    
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
        
        if !tags.isEmpty {tags.sort { ($0.value(forKey: "title") as! String) < ($1.value(forKey: "title") as! String)
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
    
    var allTasks = [TaskEntity]()

    var inboxTasks = [TaskEntity]()
    
}



