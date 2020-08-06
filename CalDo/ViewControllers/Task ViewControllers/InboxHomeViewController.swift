//
//  InboxHomeViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 11.09.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit
import CoreData

extension UITableView {
    
    // Set background image when there are no inbox tasks
    func setEmptyMessage(_ message: String) {
        
        let messageLabel = UILabel(frame: CGRect(x: 100 , y: 100, width: self.bounds.size.width, height: self.bounds.size.height))
        
//        messageLabel.center.x = self.frame.midX
//        messageLabel.center.y = self.frame.midY
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 2;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.sizeToFit()
        messageLabel.backgroundColor = UIColor.clear
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.6
        imageView.image = UIImage(named: "NothingHere")
        
        self.backgroundView = imageView
//        self.backgroundView = messageLabel;
//        self.backgroundView!.addSubview(messageLabel)
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

class InboxHomeViewController: UIViewController, InboxCellDelegate {
    
    // Get the CoreData context
    // let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // var InboxTasks = [NSManagedObject]()
    
    func checkmarkTapped(sender: InboxHomeScreenTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            // var todo = InboxTodo[indexPath.row]
            var task = CoreDataManager.shared.inboxTasks[indexPath.section]
            
            CoreDataManager.shared.inboxTasks[indexPath.row].setValue(true, forKey: "completed")
            CoreDataManager.shared.saveContext()
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
            CoreDataManager.shared.inboxTasks.remove(at: indexPath.row)
            
            UIView.animate(withDuration: 0.8){
                //                self.myTableView.deleteSections(at: [indexPath], with: .fade)
            self.tableView.deleteSections([indexPath.section], with: .fade)
            }
        }
    }
    

    let cellSpacingHeight: CGFloat = 15
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 20
        //        cell.layer.backgroundColor = UIColor(hexString: "F0F2F4").cgColor
        //
        //        cell.layer.backgroundColor = UIColor.clear.cgColor// very important
        cell.layer.masksToBounds = false
//        cell.layer.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor
//        cell.layer.shadowOpacity = 0.15
//        cell.layer.shadowRadius = 5
//        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cell.layer.shadowColor = UIColor.gray.cgColor
    }
    
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//        if CoreDataManager.shared.inboxTasks.count == 0 {
//            self.tableView.setEmptyMessage("""
//            Nothing to see here
//            Start adding Tasks
//            """
//            )
//        }
//        else {
//            self.tableView.restore()
//            self.tableView.separatorStyle = .none
//        }
//        return CoreDataManager.shared.inboxTasks.count
//    }
//
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return cellSpacingHeight
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
    
    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxHomeScreenTableViewCell", for: indexPath) as! InboxHomeScreenTableViewCell
//        let task = CoreDataManager.shared.inboxTasks[indexPath.section]
//
//        let shapeLayer = CAShapeLayer()
//        let center = CGPoint(x: cell.ProjectColor.frame.height/2, y: cell.ProjectColor.frame.width/2)
//        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(4), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
//
//
//        shapeLayer.path = circlePath.cgPath
//        shapeLayer.lineWidth = 3.0
//
//
//        shapeLayer.path = circlePath.cgPath
//        shapeLayer.lineWidth = 3.0
//
//        if let project = CoreDataManager.shared.fetchProjectFromTask(task: task) {
//            shapeLayer.fillColor = CoreDataManager.shared.projectColor(project: project)?.cgColor
//
//            cell.ProjectLabel.text = project.value(forKey: "title") as? String
//            cell.ProjectLabel.textColor = UIColor.textColor
//            cell.ProjectColor.layer.backgroundColor = UIColor.clear.cgColor
//            cell.ProjectColor.layer.addSublayer(shapeLayer)
//        }
//
//
//        cell.TodoTitle.text = task.value(forKey: "title") as? String
//        cell.TodoTitle.textColor = UIColor.textColor
//        cell.accessoryView = nil
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        cell.backgroundColor = .BackgroundColor
//        cell.delegate = self
//
//        if task.value(forKey: "completed") as! Bool == true{
//            cell.alpha = 1
//            //            let currentindex = IndexPath.init(row: indexPath.row, section: 0)
//            let image = UIImage(named: "DoneButtonPressed")
//
//            UIView.animate(
//                withDuration: 0.3,
//                animations: {
//                    cell.TodoStatus.setImage(image, for: .normal)
//            })
//        }
//        else {
//            let image = UIImage(named: "TodoButton")
//            cell.TodoStatus.setImage(image, for: .normal)
//        }
//
//        return cell
//
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    @IBOutlet weak var tableView: UITableView!
    var inboxHomeTableView: TaskTableView!

    
    
//    func checkmarkTapped(sender: InboxHomeScreenTableViewCell) {
//        print("test")
//        if let indexPath = tableView.indexPath(for: sender) {
//            //            var todo = InboxTodo[indexPath.row]
//            var todo = InboxTodo[indexPath.section]
//
//            todo.todoCompleted = !todo.todoCompleted
//            InboxTodo[indexPath.section] = todo
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//            InboxTodo.remove(at: indexPath.section)
//
//            UIView.animate(withDuration: 0.8){
//            self.tableView.deleteSections([indexPath.section], with: .fade)
//            }
//        }
//    }
    
//    func animateTable() {
//        self.tableView.reloadData()
//        let cells = tableView.visibleCells
//        let tableHeight: CGFloat = tableView.bounds.size.height
//
//        for i in cells {
//            // let cell: UITableViewCell = i as! InboxHomeScreenTableViewCell
//            let cell: UITableViewCell = i
//            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
//        }
//
//        var index = 0
//
//        for a in cells {
//            self.tableView.isHidden = false
//            UIView.animate(withDuration: 1.5, delay: 0.005 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:  .transitionFlipFromTop, animations: {
//            }, completion: nil)
//            index += 1
//        }
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataManager.shared.fetchInboxTasks()
        inboxHomeTableView = TaskTableView(tableView, CoreDataManager.shared.inboxTasks)
        inboxHomeTableView.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
//        tableView.backgroundColor = UIColor(hexString: "F0F2F4")
//        tableView.layer.cornerRadius = 20
    
        
        // Load tasks
        // loadSampleTaskEntities()
        
        // CoreDataManager.shared.inboxTasks = CoreDataManager.shared.fetchInboxTasks()
        
        // tableView.register(UINib(nibName: "InboxHomeScreenTableViewCell", bundle: nil), forCellReuseIdentifier: "InboxHomeScreenTableViewCell")
    
        tableView.backgroundColor = .BackgroundColor
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
