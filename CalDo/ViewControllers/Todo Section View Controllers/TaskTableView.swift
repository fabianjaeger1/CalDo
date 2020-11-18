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

// MARK: Table Animations
typealias TableCellAnimation = (UITableViewCell,IndexPath,UITableView) -> Void

final class TableVIewAnimator {
    private let animation: TableCellAnimation
    
    init(animation: @escaping TableCellAnimation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        animation(cell,indexPath, tableView)
    }
}

//enum TableAnimation {
//    case fadeIn(duration: TimeInterval, delay: TimeInterval)
//    case moveUp(rowHeight: CGFloat, duration: TimeInterval, delay: TimeInterval)
//    case moveUpWithFade(rowHeight: CGFloat, duration: TimeInterval, delay: TimeInterval)
//    case moveUpBounce(rowHeight: CGFloat, duration: TimeInterval, delay: TimeInterval)
//
//    //provides an animation with duration and delay associated with the case
//    func getAnimation() -> TableCellAnimation {
//        switch.self {
//
//        }
//    }
//
//}


class TaskTableView: NSObject, UITableViewDataSource, UITableViewDelegate, SmallTaskTableViewCellDelegate, TaskTableViewCellDelegate, UITableViewDragDelegate {
    
    
    func hasPerformedSwipe(passedInfo: String){
        print("Test")
    }
    
        
    
//    weak var delegate1: SmallTaskTableViewCellDelegate?
//    weak var delegate2: TaskTableViewCellDelegate?
//    var segueIdentifier: String
    var tableView: UITableView
    var tableViewData: [TaskEntity]
    var taskPredicate: NSPredicate
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredTableViewData: [TaskEntity] = []
    
    var myViewController: TaskTableViewController?
    
    var sortVariable: String = "sortOrder"
    
    init?(_ tv: UITableView, _ predicate: NSPredicate, _ sortVariable: String) {
        
        self.tableView = tv
        self.taskPredicate = predicate
        self.sortVariable = sortVariable
//        segueIdentifier = segueIdentf
        
        
        // Fetch tasks
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
        
        // Sort tasks
        self.sortTasks()
        
        // Enable dragging tasks
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true

        tableView.delegate = self
        tableView.dataSource = self

        // Register all of your cells
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        tableView.register(UINib(nibName: "SmallTaskTableViewCell", bundle: nil), forCellReuseIdentifier: "SmallTaskTableViewCell")
        
        // Set up search bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search Tasks"
        searchController.searchBar.backgroundColor = .BackgroundColor
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Observer for keyboard when editing task titles
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.keyboardDismissMode = .interactive
        
        tableView.estimatedRowHeight = 70
    }
    
    func sortTasks() {
        if !self.tableViewData.isEmpty {
            self.tableViewData.sort {
                ($0.value(forKey: self.sortVariable) as! Int) < ($1.value(forKey: self.sortVariable) as! Int)
            }
            self.saveTaskOrder()
        }
    }
    
    func saveTaskOrder() {
        var i = 0
        for task in self.tableViewData {
            task.setValue(i, forKey: self.sortVariable)
            i += 1
        }
        CoreDataManager.shared.saveContext()
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
        if isFiltering {
            return filteredTableViewData.count
        }
        return tableViewData.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task: TaskEntity
        if isFiltering {
            task = filteredTableViewData[indexPath.row]
        }
        else {
            task = self.tableViewData[indexPath.row]
        }
        
        var vcIsProject = false
        var vcIsTag = false
        
        if let vc = myViewController {
            if vc is ProjectTaskViewController {
                vcIsProject = true
            }
//            if vc is TagTaskViewController {
//                vcIsTag = true
//            }
        }
        let project = task.value(forKey: "project") as? ProjectEntity
        let projectExists = !(project == nil)
        
        let numberOfTags = (task.value(forKey: "tags") as! Set<TagEntity>).count
        
        let cellHasProject = projectExists && !vcIsProject
        let cellHasTags = (numberOfTags != 0) && !vcIsTag
        
        
        // MARK: - Small TableView Cell
        // Smaller Table View cell without Projects and Tags
        
        if !cellHasProject && !cellHasTags {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SmallTaskTableViewCell", for: indexPath) as! SmallTaskTableViewCell
            
            cell.delegate = self
            cell.myViewController = self.myViewController
            
            cell.taskTitle.delegate = self
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.backgroundColor
            cell.selectedBackgroundView = backgroundView
            
            // ========= DATE ===========
            
            // TODO: simplify by adding function returning a task's todoString
            cell.TodoDate?.text = (task.value(forKey: "date") as? Date)?.todoString(withTime: task.value(forKey: "dateHasTime") as! Bool)
            //cell.TodoDate.textColor = UIColor.textColor
            cell.TodoDate.textColor = (task.value(forKey: "date") as? Date)?.todoColor(withTime: task.value(forKey: "dateHasTime") as! Bool)
            
            // ========= TITLE ===========
            cell.taskTitle.text = (task.value(forKey: "title") as! String)
            cell.taskTitle.textColor = .textColor
            
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
                let image = UIImage(named: "TodoButton")
                cell.TodoStatus.setImage(image, for: .normal)
            case (false, 1):
                let image = UIImage(named: "Todo Medium Priority")
                cell.TodoStatus.setImage(image, for: .normal)
            case (false, 2):
                let image = UIImage(named: "Todo High Priority")
                cell.TodoStatus.setImage(image, for: .normal)
            default:
                print("Recurrence and/or priority outside of range")
            }

            cell.backgroundColor = .BackgroundColor
            // cell.backgroundColor = .clear
            // cell.layer.backgroundColor = UIColor.clear.cgColor
        //            cell.delegate = self
//            cell.selectionStyle = .none
            return cell
        }

        // MARK: - Large TableView Cell

        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
            
            cell.delegate = self
            cell.myViewController = self.myViewController
            
            cell.taskTitle.delegate = self
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.backgroundColor
            cell.selectedBackgroundView = backgroundView

            // shapeLayer.fillColor = UIColor(hexString: (todo.todoProject?.ProjectColor)!).cgColor
            // shapeLayer.fillColor = UIColor(hexString: (((task.value(forKey: "project") as! ProjectEntity?)?.value(forKey: "color") as! String?))!).cgColor
            
            if cellHasProject {
            
                let shapeLayer = CAShapeLayer()
                shapeLayer.backgroundColor = UIColor.clear.cgColor

                    // let ConvertedDate = todo.todoDate?.DatetoString(dateFormat: "HH:mm")
                    // let ConvertedDate = (task.value(forKey: "date") as! Date?)?.DatetoString(dateFormat: "HH:mm")

                let center = CGPoint(x: cell.ProjectColor.frame.height/2, y: cell.ProjectColor.frame.width/2)
                let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(4), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)

                shapeLayer.path = circlePath.cgPath
                shapeLayer.lineWidth = 3.0
                shapeLayer.fillColor = CoreDataManager.shared.projectColor(project: project!)?.cgColor

                cell.ProjectLabel.text = project!.value(forKey: "title") as? String
                cell.ProjectLabel.textColor = UIColor.textColor
                cell.ProjectColor.layer.backgroundColor = UIColor.clear.cgColor
                cell.ProjectColor.layer.addSublayer(shapeLayer)
            }

            if (task.value(forKey: "completed") as! Bool) == true {
                cell.alpha = 1
        //            let currentindex = IndexPath.init(row: indexPath.row, section: 0)
                let image = UIImage(named: "DoneButton")

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
            cell.taskTitle.text = (task.value(forKey: "title") as! String)
            cell.taskTitle.textColor = .textColor
            
            
            cell.TodoDate.text = (task.value(forKey: "date") as? Date)?.todoString(withTime: task.value(forKey: "dateHasTime") as! Bool)
            cell.TodoDate.textColor = (task.value(forKey: "date") as? Date)?.todoColor(withTime: task.value(forKey: "dateHasTime") as! Bool)

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
                else if count == 2 {
                    cell.Tag1.text = taskTagTitles[0]
                    cell.Tag1.textColor = taskTagColors[0]
                    cell.Tag2.text = taskTagTitles[1]
                    cell.Tag2.textColor = taskTagColors[1]
                }
                else if count == 3 {
                    cell.Tag1.text = taskTagTitles[0]
                    cell.Tag1.textColor = taskTagColors[0]
                    cell.Tag2.text = taskTagTitles[1]
                    cell.Tag2.textColor = taskTagColors[1]
                    cell.Tag3.text = taskTagTitles[2]
                    cell.Tag3.textColor =  taskTagColors[2]
                }
                else if count == 4 {
                    cell.Tag1.text = taskTagTitles[0]
                    cell.Tag1.textColor = taskTagColors[0]
                    cell.Tag2.text = taskTagTitles[1]
                    cell.Tag2.textColor = taskTagColors[1]
                    cell.Tag3.text = taskTagTitles[2]
                    cell.Tag3.textColor =  taskTagColors[2]
                    cell.Tag4.text = taskTagTitles[3]
                    cell.Tag4.textColor = taskTagColors[3]
                }
                else if count == 5 {
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
                let image = UIImage(named: "TodoButton")
                cell.TodoStatus.setImage(image, for: .normal)
            case (false, 1):
                let image = UIImage(named: "Todo Medium Priority")
                cell.TodoStatus.setImage(image, for: .normal)
            case (false, 2):
                let image = UIImage(named: "Todo High Priority")
                cell.TodoStatus.setImage(image, for: .normal)
            default:
                print("Recurrence and/or priority outside of range")
            }
            
            // cell.TodoStatus = TaskButton(task: task)

            // To return default case of no above cell type

//            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
        
// MARK: - Swipe Actions
        
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let select = selectAction(at: indexPath)
//        return UISwipeActionsConfiguration(actions: [select])
//    }
//
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let schedule = scheduleAction(at: indexPath)
//        return UISwipeActionsConfiguration(actions: [schedule])
//    }
//
//    func selectAction(at indexPath: IndexPath) -> UIContextualAction {
//        let action = UIContextualAction(style: .normal, title: "Select") { (action, view, completion) in
//            completion(true)
//        }
//        action.image = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in
//        UIImage(named: "Info")?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25))}
//        action.backgroundColor = UIColor(hexString: "6ABBD7")
//        action.title = ""
//
//        return action
//    }
//
//    func scheduleAction(at indexPath: IndexPath) -> UIContextualAction {
//        let action = UIContextualAction(style: .normal, title: "Schedule") { (action, view, completion) in
//            completion(true)
//        }
//        action.image = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in
//            UIImage(named: "Calendar")?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25))}
//        action.backgroundColor = UIColor(hexString: "FCCE54")
//
//        return action
//    }
    
    
// MARK: - Cell Sizing
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        //return self.cellHeightsDictionary[indexPath] ??  UITableView.automaticDimension
        return 70
    }
    
    

    
// MARK: - Delegate Methods

    func completeTask(indexPath: IndexPath) {
        let task = isFiltering ? filteredTableViewData[indexPath.row] : tableViewData[indexPath.row]
        
        task.setValue(true, forKey: "completed")
        CoreDataManager.shared.saveContext()
        
        if isFiltering {
            filteredTableViewData.remove(at: indexPath.row)
            tableViewData.removeAll(where: {taskInList -> Bool in
                return taskInList == task
            })
        }
        else {
            tableViewData.remove(at: indexPath.row)
        }
    }
    
    func completeTask(_ task: TaskEntity) {
        task.setValue(true, forKey: "completed")
        CoreDataManager.shared.saveContext()
        
        if isFiltering {
            filteredTableViewData.removeAll(where: {taskInList -> Bool in
                return taskInList == task
            })
        }
        
        tableViewData.removeAll(where: {taskInList -> Bool in
            return taskInList == task
        })
    }
    
    
    func checkmarkTapped(sender: SmallTaskTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: sender) {
            
            let task = isFiltering ? filteredTableViewData[indexPath.row] : tableViewData[indexPath.row]

            completeTask(task)
        
            // TODO: implement haptic feedback
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
            
            let image: UIImage?
            
            switch (task.value(forKey: "recurrence") as! Bool, task.value(forKey: "priority") as! Int) {
            case (true, 0):
                image = UIImage(named: "RecurringButtonPressed")
            case (true, 1):
                image = UIImage(named: "MediumRecurringButtonPressed")
            case (true, 2):
                image = UIImage(named: "HighRecurringButtonPressed")
            case (false, 0):
                image = UIImage(named: "ButtonPressed")
            case (false, 1):
                image = UIImage(named: "MediumButtonPressed")
            case (false, 2):
                image = UIImage(named: "HighButtonPressed")
            default:
                image = nil
            }
            
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    sender.TodoStatus.setImage(image, for: .normal)
                    sender.taskTitle.textColor = .gray
            })
            
            UIView.animate(withDuration: 0.5) {
//                self.myTableView.deleteSections(at: [indexPath], with: .fade)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            // self.tableView.reloadRows(at: [indexPath], with: .automatic)

            }
    }
    
    
    func checkmarkTapped1(sender: TaskTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: sender) {
            
            let task = isFiltering ? filteredTableViewData[indexPath.row] : tableViewData[indexPath.row]

            completeTask(task)
            
            // TODO: implement haptic
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        
            let image: UIImage?
            
            switch (task.value(forKey: "recurrence") as! Bool, task.value(forKey: "priority") as! Int) {
            case (true, 0):
                image = UIImage(named: "RecurringButtonPressed")
            case (true, 1):
                image = UIImage(named: "MediumRecurringButtonPressed")
            case (true, 2):
                image = UIImage(named: "HighRecurringButtonPressed")
            case (false, 0):
                image = UIImage(named: "ButtonPressed")
            case (false, 1):
                image = UIImage(named: "MediumButtonPressed")
            case (false, 2):
                image = UIImage(named: "HighButtonPressed")
            default:
                image = nil
            }
            
            UIView.animate(
                withDuration: 1.5,
                animations: {
                    sender.taskTitle.textColor = .gray
                    sender.TodoStatus.setImage(image, for: .normal)
            })

            UIView.animate(withDuration: 0.5) {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
    
    // TODO: update relevant data after editing
    func finishEditing(sender: SmallTaskTableViewCell) {
        // if let cellIndexPath = self.tableView.indexPath(for: sender) {
            //self.tableView.reloadRows(at: [cellIndexPath], with: .automatic)
        // }
    }
    
    func finishEditing1(sender: TaskTableViewCell) {
        // if let cellIndexPath = self.tableView.indexPath(for: sender) {
            //self.tableView.reloadRows(at: [cellIndexPath], with: .automatic)
        // }
    }
    
    // MARK: - Dragging to reorder
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = tableViewData[indexPath.row]
        return [dragItem]
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = tableViewData.remove(at: sourceIndexPath.row)
        tableViewData.insert(mover, at: destinationIndexPath.row)
        self.saveTaskOrder()
    }
    
    
    // MARK: - Search Bar
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterTasksForSearchText(_ searchText: String) {
        filteredTableViewData = tableViewData.filter { (task: TaskEntity) -> Bool in
            return task.title!.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Context menu
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let task = isFiltering ? filteredTableViewData[indexPath.row] : tableViewData[indexPath.row]
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
            if let cell = self.tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                // self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                cell.titleIsInEditingMode = true
            }
            else if let cell = self.tableView.cellForRow(at: indexPath) as? SmallTaskTableViewCell {
                cell.titleIsInEditingMode = true
            }
           
        }
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            
            let alert = UIAlertController(title: "Delete task?", message: "This action cannot be undone.", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.tableViewData.remove(at: indexPath.row)
                CoreDataManager.shared.deleteTask(task)
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
            newTask.inboxOrder = task.inboxOrder
            newTask.upcomingOrder = task.upcomingOrder
            newTask.todayOrder = task.todayOrder
            newTask.projectOrder = task.projectOrder
            newTask.allOrder = task.allOrder
            newTask.tagOrder = task.tagOrder
            
            if self.isFiltering {
                self.filteredTableViewData.insert(newTask, at: indexPath.row)
            }
            
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

    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard
            let identifier = configuration.identifier as? String
        else {
            return nil
        }

        let index = Int(identifier)! as Int
        let indexPath = IndexPath(row: index, section:0)
        
        /// Renaming task title
        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            if cell.titleIsInEditingMode {
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                cell.taskTitle.isUserInteractionEnabled = true
                cell.taskTitle.becomeFirstResponder()
                cell.taskTitle.invalidateIntrinsicContentSize()
                cell.titleIsInEditingMode = false
                let indexPath = tableView.indexPath(for: cell)
                
                //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                if indexPath != nil {
                    tableView.scrollToRow(at: indexPath!, at: .middle, animated: true)
                }
            }
            else {
                 tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        else if let cell = tableView.cellForRow(at: indexPath) as? SmallTaskTableViewCell {
            if cell.titleIsInEditingMode {
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                cell.taskTitle.isUserInteractionEnabled = true
                cell.taskTitle.becomeFirstResponder()
                cell.taskTitle.invalidateIntrinsicContentSize()
                cell.titleIsInEditingMode = false
                let indexPath = tableView.indexPath(for: cell)
                
                //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                if indexPath != nil {
                    tableView.scrollToRow(at: indexPath!, at: .middle, animated: true)
                }
            }
            else {
                 tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        

        if let cell = tableView.cellForRow(at: indexPath) {
        // let cellBackground = cell.backgroundView
        // cell.backgroundColor == UIColor.BackgroundColor
            return UITargetedPreview(view: cell)
        }
        else {
            return nil
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {

        // Insert extra height for iPhone 8 style phones (not great, but don't know how else..)
        var extraHeight = CGFloat(0.0)
        if ["iPhone 6s", "iPhone 6s Plus", "iPhone 7", "iPhone 7 Plus", "iPhone 8", "iPhone 8 Plus", "iPhone SE (2nd generation)"].contains(UIDevice.current.modelName) {
            extraHeight += 30.0
        }
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height + extraHeight, right: 0.0)
        
        if let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow {
            if let cell = tableView.cellForRow(at: indexPathForSelectedRow) as? TaskTableViewCell {

                let cellRect = cell.frame
                let tableViewRect = tableView.frame
                // let window = UIApplication.shared.keyWindow?.frame

                // TODO: Fix for tableview in home screen
                if (tableViewRect.height - cellRect.maxY) <= keyboardFrame.height {
                    tableView.contentInset = contentInset
                    tableView.scrollIndicatorInsets = contentInset
                    tableView.scrollToRow(at: indexPathForSelectedRow, at: .middle, animated: true)
                    //tableView.scrollRectToVisible(cellRect, animated: true)
                }
            }
            else if let cell = tableView.cellForRow(at: indexPathForSelectedRow) as? SmallTaskTableViewCell {
                let cellRect = cell.frame
                let tableViewRect = tableView.frame

                // TODO: Fix for tableview in home screen
                if (tableViewRect.height - cellRect.maxY) <= keyboardFrame.height {
                    tableView.contentInset = contentInset
                    tableView.scrollIndicatorInsets = contentInset
                    tableView.scrollToRow(at: indexPathForSelectedRow, at: .middle, animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset
    }
}

extension TaskTableView: UITextFieldDelegate {
    /// TODO: necessary?
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isUserInteractionEnabled = false
        
        if let newTitle = textField.text {
            if let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow {
                tableViewData[indexPathForSelectedRow.row].setValue(newTitle, forKey: "title")
                CoreDataManager.shared.saveContext()
                self.tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
        }
        return true
    }
    
}



extension TaskTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterTasksForSearchText(searchBar.text!)
    }
}

// MARK: - Detail View

extension TaskTableView: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = DetailPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.detailDelegate = self
        return presentationController
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = isFiltering ? filteredTableViewData[indexPath.row] : tableViewData[indexPath.row]
        let vc = DetailViewController(nibName: "DetailViewController", bundle: nil, task: task, indexPath: indexPath)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        
        if !(self.myViewController?.realIsEditing ?? false) {
            if isFiltering {
                searchController.present(vc, animated: true)
            }
            else {
                self.myViewController?.present(vc, animated: true)
            }
        }
    }
}

extension TaskTableView: DetailPresentationControllerDelegate {
    func drawerMovedTo(position: DetailSnapPoint) {
        if position == .closed {
            if let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow {
                
                self.tableView.reloadRows(at: [indexPathForSelectedRow], with: .fade)
                //self.tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
        }
    }
    
    func completeTaskInDetail(_ task: TaskEntity, indexPath: IndexPath) {
        completeTask(task)
        UIView.animate(withDuration: 0.5) {
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
