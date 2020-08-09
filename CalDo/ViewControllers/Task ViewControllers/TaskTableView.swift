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


class TaskTableView: NSObject, UITableViewDataSource, UITableViewDelegate, SmallTaskTableViewCellDelegate, TaskTableViewCellDelegate{
    

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
            
            //========= DATE ===========
            
            // TODO: simplify by adding function returning a task's todoString
            cell.TodoDate?.text = (task.value(forKey: "date") as? Date)?.todoString(withTime: task.value(forKey: "dateHasTime") as! Bool)
            //cell.TodoDate.textColor = UIColor.textColor
            cell.TodoDate.textColor = (task.value(forKey: "date") as? Date)?.todoColor(withTime: task.value(forKey: "dateHasTime") as! Bool)
            
            //========= TITLE ===========
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
            
            // ======= CELL TODO BUTTON =========
                    
                    if (task.value(forKey: "recurrence") as! Bool) == true && (task.value(forKey: "priority") as! Int) == 1 {
                        let image = UIImage(named: "Recurring Normal")
                        cell.TodoStatus.setImage(image, for: .normal)
                    }
                     if (task.value(forKey: "recurrence") as! Bool) == true && (task.value(forKey: "priority") as! Int) == 2 {
                        let image = UIImage(named: "Recurring High")
                        cell.TodoStatus.setImage(image, for: .normal)
                    }
                    
                    if (task.value(forKey: "recurrence") as! Bool) != true && (task.value(forKey: "priority") as! Int) == 1 {
                        let image = UIImage(named: "Todo Medium Priority")
                        cell.TodoStatus.setImage(image, for: .normal)
                    }
                    if (task.value(forKey: "recurrence") as! Bool) != true && (task.value(forKey: "priority") as! Int) == 2 {
                        let image = UIImage(named: "Todo High Priority")
                        cell.TodoStatus.setImage(image, for: .normal)
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
            
        //            cell.backgroundColor = .BackgroundColor
            cell.backgroundColor = .clear
            cell.layer.backgroundColor = UIColor.clear.cgColor
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
            cell.backgroundColor = .clear

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

            if (task.value(forKey: "recurrence") as! Bool) == true && (task.value(forKey: "priority") as! Int) == 1 {
                let image = UIImage(named: "Recurring Normal")
                cell.TodoStatus.setImage(image, for: .normal)
            }
             if (task.value(forKey: "recurrence") as! Bool) == true && (task.value(forKey: "priority") as! Int) == 2 {
                let image = UIImage(named: "Recurring High")
                cell.TodoStatus.setImage(image, for: .normal)
            }

            if (task.value(forKey: "recurrence") as! Bool) != true && (task.value(forKey: "priority") as! Int) == 1 {
                let image = UIImage(named: "Todo Medium Priority")
                cell.TodoStatus.setImage(image, for: .normal)
            }
            if (task.value(forKey: "recurrence") as! Bool) != true && (task.value(forKey: "priority") as! Int) == 2 {
                let image = UIImage(named: "Todo High Priority")
                cell.TodoStatus.setImage(image, for: .normal)
            }

            // To return default case of no above Cell type

            return cell
        }
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
}





