//
//  TaskTableView.swift
//  CalDo
//
//  Created by Nathan Baudis  on 8/6/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class TaskTableView: NSObject, UITableViewDataSource, UITableViewDelegate, SmallTaskTableViewCellDelegate, TaskTableViewCellDelegate, UITableViewDragDelegate {
    
    
//    weak var delegate1: SmallTaskTableViewCellDelegate?
//    weak var delegate2: TaskTableViewCellDelegate?
    var tableView: UITableView
    var tableViewData: [TaskEntity]
    var taskPredicate: NSPredicate

    init?(_ tv: UITableView, _ predicate: NSPredicate) {
        
        tableView = tv
        taskPredicate = predicate
        
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let predicate = self.taskPredicate
        request.predicate = predicate
        
//        throws {
//        do {
//                self.tableViewData = try managedContext.fetch(request)
//            } catch let error as NSError {
//                print("Error fetching tasks from context \(error)")
//                throw error
//            }
//        }
//
        do {
            self.tableViewData = try managedContext.fetch(request)
        } catch {
            print("Error fetching tasks from context \(error)")
            return nil
        }
        
        super.init()
        
        // Enable dragging tasks
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true

        tableView.delegate = self
        tableView.dataSource = self

        // Register all of your cells
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        tableView.register(UINib(nibName: "SmallTaskTableViewCell", bundle: nil), forCellReuseIdentifier: "SmallTaskTableViewCell")
    }
    
    func refreshTableViewData() {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let predicate = self.taskPredicate
        request.predicate = predicate
          
        do {
            self.tableViewData = try managedContext.fetch(request)
        } catch {
            print("Error fetching tasks from context \(error)")
        }
        
        // TODO: necessary?
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let task = self.tableViewData[indexPath.row]
            
        // Smaller Table View cell without Projects and Tags
        if task.value(forKey: "project") == nil && (task.value(forKey: "tags") as! Set<TagEntity>).count == 0 {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SmallTaskTableViewCell", for: indexPath) as! SmallTaskTableViewCell
            
            // ========= DATE ===========
            
            // TODO: simplify by adding function returning a task's todoString
            cell.TodoDate?.text = (task.value(forKey: "date") as? Date)?.todoString(withTime: task.value(forKey: "dateHasTime") as! Bool)
            //cell.TodoDate.textColor = UIColor.textColor
            cell.TodoDate.textColor = (task.value(forKey: "date") as? Date)?.todoColor(withTime: task.value(forKey: "dateHasTime") as! Bool)
            
            // ========= TITLE ===========
            cell.TodoTitle?.text = (task.value(forKey: "title") as! String)
            cell.TodoTitle.textColor = UIColor.textColor
            cell.delegate = self
            
            if task.value(forKey: "notes") != nil {
                cell.TodoNotesIcon.alpha = 1
            }
            else {
                cell.TodoNotesIcon.alpha = 0
            }
            if task.value(forKey: "location") == nil {
                cell.TodoLocationIcon.alpha = 0
            }
            else {
                cell.TodoLocationIcon.alpha = 1
            }
            
            // ================== CELL TODO BUTTON =======================
                
            switch(task.value(forKey: "recurrence") as! Bool, task.value(forKey: "priority") as! Int) {
            case (true, 0):
                let image = UIImage(named: "Recurring")
                cell.TodoStatus.setImage(image, for: .normal)
            case (true, 1):
                let image = UIImage(named: "Recurring Normal")
                cell.TodoStatus.setImage(image, for: .normal)
            case (true, 2):
                let image = UIImage(named: "Recurring High")
                cell.TodoStatus.setImage(image, for: .normal)
            case (false, 0):
                break
            case (false, 1):
                let image = UIImage(named: "Todo Medium Priority")
                cell.TodoStatus.setImage(image, for: .normal)
            case (false, 2):
                let image = UIImage(named: "Todo High Priority")
                cell.TodoStatus.setImage(image, for: .normal)
            default:
                print("Recurrence and/or priority outside of range")
            }

            // =========== ANIMATION ==================
            
            // TODO: remove, moved to checkmarktapped
            
            if (task.value(forKey: "completed") as! Bool) == true {
                cell.alpha = 1
                let image = UIImage(named: "DoneButtonPressed")
            
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        cell.TodoStatus.setImage(image, for: .normal)
                })
            }
            else {
                let image = UIImage(named: "TodoButton")
                cell.TodoStatus.setImage(image, for: .normal)
            }
            
            cell.backgroundColor = .BackgroundColor
            // cell.backgroundColor = .clear
            // cell.layer.backgroundColor = UIColor.clear.cgColor
        //            cell.delegate = self
            
            return cell
        }

        // GENERAL CASE

        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
            
            cell.delegate = self

            // shapeLayer.fillColor = UIColor(hexString: (todo.todoProject?.ProjectColor)!).cgColor
            // shapeLayer.fillColor = UIColor(hexString: (((task.value(forKey: "project") as! ProjectEntity?)?.value(forKey: "color") as! String?))!).cgColor
             if let project = CoreDataManager.shared.fetchProjectFromTask(task: task) {
                let shapeLayer = CAShapeLayer()
                shapeLayer.backgroundColor = UIColor.clear.cgColor

                    // let ConvertedDate = todo.todoDate?.DatetoString(dateFormat: "HH:mm")
                    // let ConvertedDate = (task.value(forKey: "date") as! Date?)?.DatetoString(dateFormat: "HH:mm")

                let center = CGPoint(x: cell.ProjectColor.frame.height/2, y: cell.ProjectColor.frame.width/2)
                let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(4), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)

                shapeLayer.path = circlePath.cgPath
                shapeLayer.lineWidth = 3.0
                shapeLayer.fillColor = CoreDataManager.shared.projectColor(project: project)?.cgColor

                cell.ProjectLabel.text = project.value(forKey: "title") as? String
                cell.ProjectLabel.textColor = UIColor.textColor
                cell.ProjectColor.layer.backgroundColor = UIColor.clear.cgColor
                cell.ProjectColor.layer.addSublayer(shapeLayer)
            }


            if (task.value(forKey: "completed") as! Bool) == true {
                cell.alpha = 1
        //            let currentindex = IndexPath.init(row: indexPath.row, section: 0)
                let image = UIImage(named: "DoneButtonPressed")

                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        cell.TodoStatus.setImage(image, for: .normal)
                })
            }
            else {
                let image = UIImage(named: "TodoButton")
                cell.TodoStatus.setImage(image, for: .normal)
            }

            // cell.delegate = self
            cell.TodoTitle.text = (task.value(forKey: "title") as! String)
            cell.TodoTitle.textColor = UIColor.textColor
            
            cell.TodoDate.text = (task.value(forKey: "date") as? Date)?.todoString(withTime: task.value(forKey: "dateHasTime") as! Bool)
            cell.TodoDate.textColor = (task.value(forKey: "date") as? Date)?.todoColor(withTime: task.value(forKey: "dateHasTime") as! Bool)
            
            cell.ProjectLabel.textColor = UIColor.textColor
            // cell.TodoDate?.text = DateToString(date: todo.todoDate!)
            cell.ProjectLabel.text = (task.value(forKey: "project") as? ProjectEntity)?.value(forKey: "title") as? String
            // cell.backgroundColor = .clear
            cell.backgroundColor = .BackgroundColor


        // ====================== TAGS ================================


            let taskTagsSet = task.value(forKey: "tags") as! Set<TagEntity>
            var taskTags = Array(taskTagsSet)


            if !taskTags.isEmpty {taskTags.sort { ($0.value(forKey: "title") as! String) < ($1.value(forKey: "title") as! String)
                }
            }

            var taskTagTitles = [String]()
            var taskTagColors = [UIColor]()

            for tag in taskTags {
                taskTagTitles.append(tag.value(forKey: "title") as! String)
                taskTagColors.append(UIColor(hexString: tag.value(forKey: "color") as! String))
            }

            if taskTags.isEmpty {
            }
            else {
                let count = taskTags.count
                if count == 1 {
                    //cell.Tag1.text = todo.todoTags![0].tagLabel!
                    //cell.Tag1.textColor = todo.todoTags![0].tagColor!
                    cell.Tag1.text = taskTagTitles[0]
                    cell.Tag1.textColor = taskTagColors[0]
                }
                else if count == 2{
                    cell.Tag1.text = taskTagTitles[0]
                    cell.Tag1.textColor = taskTagColors[0]
                    cell.Tag2.text = taskTagTitles[1]
                    cell.Tag2.textColor = taskTagColors[1]
                }
                else if count == 3{
                    cell.Tag1.text = taskTagTitles[0]
                    cell.Tag1.textColor = taskTagColors[0]
                    cell.Tag2.text = taskTagTitles[1]
                    cell.Tag2.textColor = taskTagColors[1]
                    cell.Tag3.text = taskTagTitles[2]
                    cell.Tag3.textColor =  taskTagColors[2]
                }
                else if count == 4{
                    cell.Tag1.text = taskTagTitles[0]
                    cell.Tag1.textColor = taskTagColors[0]
                    cell.Tag2.text = taskTagTitles[1]
                    cell.Tag2.textColor = taskTagColors[1]
                    cell.Tag3.text = taskTagTitles[2]
                    cell.Tag3.textColor =  taskTagColors[2]
                    cell.Tag4.text = taskTagTitles[3]
                    cell.Tag4.textColor = taskTagColors[3]
                }
                else if count == 5{
                    cell.Tag1.text = taskTagTitles[0]
                    cell.Tag1.textColor = taskTagColors[0]
                    cell.Tag2.text = taskTagTitles[1]
                    cell.Tag2.textColor = taskTagColors[1]
                    cell.Tag3.text = taskTagTitles[2]
                    cell.Tag3.textColor =  taskTagColors[2]
                    cell.Tag4.text = taskTagTitles[3]
                    cell.Tag4.textColor = taskTagColors[3]
                    cell.Tag5.text = taskTagTitles[4]
                    cell.Tag5.textColor = taskTagColors[4]
                }
            }


        // =============== CELL ICONS =======================
            if task.value(forKey: "notes") != nil {
                cell.TodoNotesIcon.alpha = 1
            }
            else {
                cell.TodoNotesIcon.alpha = 0
            }

            if task.value(forKey: "location") == nil {
                cell.TodoLocationIcon.alpha = 0
            }
            else {
                cell.TodoLocationIcon.alpha = 1
            }
        // ================== CELL TODO BUTTON =======================
            
            switch(task.value(forKey: "recurrence") as! Bool, task.value(forKey: "priority") as! Int) {
            case (true, 0):
                let image = UIImage(named: "Recurring")
                cell.TodoStatus.setImage(image, for: .normal)
            case (true, 1):
                let image = UIImage(named: "Recurring Normal")
                cell.TodoStatus.setImage(image, for: .normal)
            case (true, 2):
                let image = UIImage(named: "Recurring High")
                cell.TodoStatus.setImage(image, for: .normal)
            case (false, 0):
                break
            case (false, 1):
                let image = UIImage(named: "Todo Medium Priority")
                cell.TodoStatus.setImage(image, for: .normal)
            case (false, 2):
                let image = UIImage(named: "Todo High Priority")
                cell.TodoStatus.setImage(image, for: .normal)
            default:
                print("Recurrence and/or priority outside of range")
            }

            // To return default case of no above cell type

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
        
    //================== SWIPE ACTIONS ==================
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let Schedule = ScheduleAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [Schedule])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let Select = SelectAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [Select])
    }
    
    func SelectAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Select") { (action, view, completion) in
            completion(true)
        }
        action.image = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in
        UIImage(named: "Info")?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25))}
        action.backgroundColor = UIColor(hexString: "6ABBD7")

        
        return action
    }
    
    func ScheduleAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Schedule") { (action, view, completion) in
            completion(true)
        }
        action.image = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in
            UIImage(named: "Calendar")?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25))}
        action.backgroundColor = UIColor(hexString: "FCCE54")
        
        return action
    }
    
    @IBAction func swipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended
        {
            // Perform Action
            }
    }
    
    //=============== DELEGATE METHODS =======================
        
    func checkmarkTapped(sender: SmallTaskTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: sender) {
            print("test")
            
            // ALLTASKS
            
            
//            CoreDataManager.shared.allTasks[indexPath.row].setValue(true, forKey: "completed")
//            CoreDataManager.shared.saveContext()
//            CoreDataManager.shared.allTasks.remove(at: indexPath.row)
            
            self.tableViewData[indexPath.row].setValue(true, forKey: "completed")
            CoreDataManager.shared.saveContext()
                
            // self.tableViewData = CoreDataManager.shared.allTasks
            self.tableViewData.remove(at: indexPath.row)
        
            // TODO: implement haptic
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
            
            
            let image = UIImage(named: "DoneButtonPressed")
            
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    sender.TodoStatus.setImage(image, for: .normal)
            })
            
            UIView.animate(withDuration: 0.8){
//                self.myTableView.deleteSections(at: [indexPath], with: .fade)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            // self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            
            }
    }
    
    
    func checkmarkTapped1(sender: TaskTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: sender) {
            print("test")
            
            // ALLTASKS
            
//            CoreDataManager.shared.allTasks[indexPath.row].setValue(true, forKey: "completed")
//            CoreDataManager.shared.saveContext()
//            CoreDataManager.shared.allTasks.remove(at: indexPath.row)
            
            self.tableViewData[indexPath.row].setValue(true, forKey: "completed")
            CoreDataManager.shared.saveContext()
            
            // self.tableViewData = CoreDataManager.shared.allTasks
            self.tableViewData.remove(at: indexPath.row)
            
            // TODO: implement haptic
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        
            let image = UIImage(named: "DoneButtonPressed")
            
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    sender.TodoStatus.setImage(image, for: .normal)
            })

            
            UIView.animate(withDuration: 0.8){
    //          self.myTableView.deleteSections(at: [indexPath], with: .fade)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            // self.tableView.reloadRows(at: [indexPath], with: .automatic)

            
        }
    }
    
    func finishEditing(sender: SmallTaskTableViewCell) {
        if let cellIndexPath = self.tableView.indexPath(for: sender) {
            // TODO: only update todostatus to stop flickering
            self.tableView.reloadRows(at: [cellIndexPath], with: .automatic)
        }
    }
    
    func finishEditing1(sender: TaskTableViewCell) {
        if let cellIndexPath = self.tableView.indexPath(for: sender) {
            // TODO: only update todostatus to stop flickering
            self.tableView.reloadRows(at: [cellIndexPath], with: .automatic)
        }
    }
    
    // MARK: - Dragging to reorder
    
    // TODO: save order after reordering
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = tableViewData[indexPath.row]
        return [dragItem]
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = tableViewData.remove(at: sourceIndexPath.row)
        tableViewData.insert(mover, at: destinationIndexPath.row)
    }
    
    
    // MARK: - Context menu
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let task = tableViewData[indexPath.row]
        let identifier = "\(indexPath.row)" as NSString
        
        let scheduleAction = UIAction(title: "Schedule", image: UIImage(systemName: "calendar")) { action in
                   
               }
        
        let priority0Action = UIAction(title: "Priority 3", image: UIImage(systemName: "flag")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)) { action in
            CoreDataManager.shared.setTaskPriority(task: task, priority: 0)
            // tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        let priority1Action = UIAction(title: "Priority 2", image: UIImage(systemName: "flag")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)) { action in
            CoreDataManager.shared.setTaskPriority(task: task, priority: 1)
            //tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        let priority2Action = UIAction(title: "Priority 1", image: UIImage(systemName: "flag")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)) { action in
            CoreDataManager.shared.setTaskPriority(task: task, priority: 2)
            //tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        let priorityMenu = UIMenu(title: "Priority", image: UIImage(systemName: "flag"), children: [priority2Action, priority1Action, priority0Action])
        
        let renameAction = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { action in
            
        }
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            
            let alert = UIAlertController(title: "Delete task?", message: "This action cannot be undone.", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.tableViewData.remove(at: indexPath.row)
                CoreDataManager.shared.deleteTask(task: task)
                UIView.animate(withDuration: 0.35) {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }

            // Add the actions to the alert controller
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)

            // Present the alert controller
            if var rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = rootViewController.presentedViewController {
                    rootViewController = presentedViewController
                }
                rootViewController.present(alert, animated: true, completion: nil)
            }
        }
        
        let duplicateAction = UIAction(title: "Duplicate", image: UIImage(systemName: "plus.square.on.square")) {_ in
            let newTask = TaskEntity(context: CoreDataManager.shared.persistentContainer.viewContext)
            
            // TODO: add function to copy tasks
            newTask.completed = task.completed
            newTask.title = task.title
            newTask.project = task.project
            newTask.tags = task.tags
            newTask.location = task.location
            newTask.date = task.date
            newTask.dateHasTime = task.dateHasTime
            newTask.notes = task.notes
            newTask.priority = task.priority
            newTask.recurrence = task.recurrence
            newTask.sortOrder = task.sortOrder
            
            self.tableViewData.insert(newTask, at: indexPath.row)
            CoreDataManager.shared.saveContext()
            self.tableView.insertRows(at: [indexPath], with: .fade)
        }
        
        // Inline submenu (to get a separator)
        let editMenu = UIMenu(title: "Edit...", options: .displayInline, children: [scheduleAction, priorityMenu, renameAction, duplicateAction])
        
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil, actionProvider: { _ in
            UIMenu(title: "", identifier: nil, children: [editMenu, deleteAction])
        })
    }
    
//    @available(iOS 13.0, *)
//    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
//
//        guard
//            let identifier = configuration.identifier as? String,
//            let index = Int(identifier),
//            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)),
//            let cellBackground = cell.backgroundView
//            // cell.backgroundColor == UIColor.BackgroundColor
//
//        else {
//            return nil
//        }
//
//        print("preview used")
//        return UITargetedPreview(view: cellBackground)
//    }
//
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

        guard
            let identifier = configuration.identifier as? String
        else {
            return nil
        }

        let index = Int(identifier)! as Int
        let indexPath = IndexPath(row: index, section:0)
        tableView.reloadRows(at: [indexPath], with: .none)
        let cell = tableView.cellForRow(at: indexPath)
        // let cellBackground = cell.backgroundView
        // cell.backgroundColor == UIColor.BackgroundColor

        return UITargetedPreview(view: cell!)
    }
    
}





