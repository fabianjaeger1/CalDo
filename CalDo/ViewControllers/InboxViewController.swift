//
//  FirstViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 09.10.17.
//  Copyright © 2017 CalDo. All rights reserved.
//

import UIKit
import CoreData
//import ViewAnimator

//extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(collectionView: UICollectionView,
//        numberOfItemsInSection section: Int) -> Int {
//
//        return model[collectionView.tag].count
//    }
//
//    func collectionView(collectionView: UICollectionView,
//        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell",
//            forIndexPath: indexPath)
//
//        cell.backgroundColor = model[collectionView.tag][indexPath.item]
//
//        return cell
//    }
//}


// var InboxTodo = [TodoItem]() // Globally defined variable for Todo items in Inbox

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ToDoCellDelegate {
    
    // Get the CoreData context
    // let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // var InboxTasks = [NSManagedObject]()
    // var InboxTasks = loadSampleTaskEntities()
    
    let impact = UIImpactFeedbackGenerator()
    
    var myIndex = 0
    var deleteThisPlease = [TodoItem]()
    
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var InboxLabel: UILabel!
    @IBOutlet weak var MenuButton: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func showActionSheet(_ sender : AnyObject) {
        // Print out what button was tapped
        func printActionTitle(_ action: UIAlertAction) {
            print("You tapped \(action.title!)")
        }

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Select Tasks", style: .default, handler: printActionTitle))
        alertController.addAction(UIAlertAction(title: "Filter", style: .default, handler: printActionTitle))
        alertController.addAction(UIAlertAction(title: "Share Chat", style: .destructive, handler: printActionTitle))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: printActionTitle))
        self.present(alertController, animated: true, completion: nil)
    }

//    @IBAction func BackButtonPressed(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    
    
//    func animateTable() {
//        self.myTableView.reloadData()
//        let cells = myTableView.visibleCells
//        let tableHeight: CGFloat = myTableView.bounds.size.height
//
//        for i in cells {
//            let cell: UITableViewCell = i as! InboxTableViewCell
//            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
//        }
//
//        var index = 0
//
//        for a in cells {
//            self.myTableView.isHidden = false
//            UIView.animate(withDuration: 1.5, delay: 0.005 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:  .transitionFlipFromTop, animations: {
//            }, completion: nil)
//            index += 1
//        }
//
//    }
//
    
    
//==================== TABLE VIEW METHODS ===========================
    
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
////        return (InboxTodo.count)
//        return 1
//    }
//
//    let cellSpacingHeight: CGFloat = 10
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return InboxTodo.count
//    }
//
//    // Set the spacing between sections
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return cellSpacingHeight
//    }
//
//    // Make the background color show through
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
    
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        guard let tableViewCell = cell as? InboxTableViewCell else { return }
//        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
//    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inboxTasks.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithIcon", for: indexPath) as! InboxTableViewCell
        
        let shapeLayer = CAShapeLayer()
        let task = inboxTasks[indexPath.row]
        //let ConvertedDate = todo.todoDate?.DatetoString(dateFormat: "HH:mm")
        let ConvertedDate = (task.value(forKey: "date") as! Date?)?.DatetoString(dateFormat: "HH:mm")

        let center = CGPoint(x: cell.ProjectColor.frame.height/2, y: cell.ProjectColor.frame.width/2)
        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(4), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)

        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 3.0


        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 3.0
        
        // shapeLayer.fillColor = UIColor(hexString: (todo.todoProject?.ProjectColor)!).cgColor
        // shapeLayer.fillColor = UIColor(hexString: (((task.value(forKey: "project") as! ProjectEntity?)?.value(forKey: "color") as! String?))!).cgColor
         if let project = CoreDataManager.shared.fetchProjectFromTask(task: task as! TaskEntity) {
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
        
        cell.delegate = self
        cell.TodoTitle?.text = (task.value(forKey: "title") as! String)
        cell.TodoTitle.textColor = UIColor.textColor
        cell.TodoDate.textColor = UIColor.textColor
        cell.TodoDate?.text = ConvertedDate
        
  
// ====================== TAGS ================================
        
        print(task.value(forKey: "title") as! String)
        
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
        
        //if todo.todoTags!.isEmpty {
        
        //if (task.value(forKey: "tags") as! [TaskEntity]).isEmpty {
        
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
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
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
        
        return cell
        
    }
    
//        cell.layer.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor
//        cell.layer.cornerRadius = 20
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
//        if editingStyle == UITableViewCell.EditingStyle.delete
//        {
//            InboxTodo.remove(at: indexPath.section)
//            myTableView.deleteSections([indexPath.section], with: .bottom)
////            myTableView.deleteRows(at: [indexPath], with: .bottom)
//            myTableView.reloadData()
//        }
//    }
    
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
     
    
    override func viewDidLoad() {
        
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                self.MenuButton.setImage(UIImage(named: "Down_bright"), for: .normal)
            }
        } else {
            // Fallback on earlier versions
        }
        InboxLabel.textColor = UIColor.textColor
        SearchBar.barTintColor = UIColor.white
        SearchBar.isTranslucent = false
        SearchBar.tintColor = UIColor.blue
        myTableView.backgroundColor = .BackgroundColor
        
        self.view.backgroundColor = UIColor.BackgroundColor
        
        AddButton.createFloatingActionButton()
        
        super.viewDidLoad()

        // Load tasks
        // loadSampleTaskEntities()
        // loadTasks()
        CoreDataManager.shared.fetchInboxTasks()
        
        
        // InboxTodo = TodoItem.loadSampleToDos()
//        if let savedToDos = TodoItem.loadToDos() {
//            InboxTodo = savedToDos
//        } else {
//            TodoItem.loadSampleToDos()
    
//
//        // IF there are saved todos append to InboxTodo or else load SampleToDos from Todo Struct

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
//=============== DELEGATE METHODS =======================
    
    func checkmarkTapped(sender: InboxTableViewCell) {
        if let indexPath = myTableView.indexPath(for: sender) {
            
            inboxTasks[indexPath.row].setValue(true, forKey: "completed")
            print(inboxTasks[indexPath.row].value(forKey: "title") as! String)
            // saveTasks()
            CoreDataManager.shared.saveContext()

            // task.completed = !task.completed
            // InboxTasks[indexPath.row] = task
            impact.impactOccurred()
            myTableView.reloadRows(at: [indexPath], with: .automatic)
            
            inboxTasks.remove(at: indexPath.row)
            
            UIView.animate(withDuration: 0.8){
//                self.myTableView.deleteSections(at: [indexPath], with: .fade)
                self.myTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
//            myTableView.reloadData()
            
         
        
        }
    }
    
    
}

