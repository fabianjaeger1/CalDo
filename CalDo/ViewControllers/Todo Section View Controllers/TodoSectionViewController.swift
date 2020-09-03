//
//  TodoSectionViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 11.09.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit

extension UIColor {
class var textColor: UIColor {
    if let color = UIColor(named: "TextColor") {
        return color
    }
    fatalError("Could not find appBG color")
  }
    class var backgroundColor: UIColor {
        if let color = UIColor(named: "CustomBackgroundColor") {
            return color
        }
        fatalError("Could not find color")
    }
    class var BackgroundColor: UIColor {
        if let color = UIColor(named: "BackgroundColor") {
            return color
        }
        fatalError("Could not find")
    }
}

let todoSections = ["Inbox", "Today", "Upcoming", "All Tasks"]


class TodoSectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIAdaptivePresentationControllerDelegate, ProjectTableViewDelegate {
    
    
    @IBOutlet weak var myTableView: UITableView!
    var projectTableView: ProjectTableView! {
        didSet {
            projectTableView.delegate = self
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var myView: UIView!
    
    
// MARK: Todo Collection View Methods
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todoSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath == NSIndexPath(row: 0, section: 0) as IndexPath{
            let vc = InboxViewController(nibName: "TaskTableViewController", bundle: nil)
            vc.presentationController?.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath == NSIndexPath(row: 1, section: 0) as IndexPath{
            let vc = TodayViewController(nibName: "TaskTableViewController", bundle: nil)
            vc.presentationController?.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath == NSIndexPath(row: 2, section: 0) as IndexPath{
            let vc = UpcomingViewController(nibName: "TaskTableViewController", bundle: nil)
            vc.presentationController?.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath == NSIndexPath(row: 3, section: 0) as IndexPath{
            let vc = AllTasksViewController(nibName: "TaskTableViewController", bundle: nil)
            vc.presentationController?.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoSectionCollectionViewCell", for: indexPath) as! TodoSectionCollectionViewCell
    
        switch indexPath.row {
        case 0:
            cell.TodoSection.image = UIImage(named: "Inbox_Home")
            
            CoreDataManager.shared.fetchInboxTasks()
            let inboxTaskAmount = CoreDataManager.shared.inboxTasks.count
            if inboxTaskAmount == 1 {
                cell.TodoAmountLabel.text = "1 Task"
            }
            else {
                cell.TodoAmountLabel.text = "\(inboxTaskAmount) Tasks"
            }

        case 1:
            cell.TodoSection.image = UIImage(named: "Today_Todo")
            
            CoreDataManager.shared.fetchTodayTasks()
            let todayTaskAmount = CoreDataManager.shared.todayTasks.count
            if todayTaskAmount == 1 {
                cell.TodoAmountLabel.text = "1 Task"
            }
            else {
                cell.TodoAmountLabel.text = "\(todayTaskAmount) Tasks"
            }
            
        case 2:
             cell.TodoSection.image = UIImage(named: "Scheduled")
            
            CoreDataManager.shared.fetchUpcomingTasks()
            let upcomingTaskAmount = CoreDataManager.shared.upcomingTasks.count
            if upcomingTaskAmount == 1 {
                cell.TodoAmountLabel.text = "1 Task"
            }
            else {
                cell.TodoAmountLabel.text = "\(upcomingTaskAmount) Tasks"
            }
            
        case 3:
            cell.TodoSection.image = UIImage(named: "All_Tasks")
            
            CoreDataManager.shared.fetchAllTasks()
            let allTasksAmount = CoreDataManager.shared.allTasks.count
            if allTasksAmount == 1 {
                cell.TodoAmountLabel.text = "1 Task"
            }
            else {
                cell.TodoAmountLabel.text = "\(allTasksAmount) Tasks"
            }
        default:
            print("None")
        }
        cell.layer.cornerRadius = 25
        cell.TodoAmountLabel.textColor = UIColor.textColor
        cell.TodoSectionLabel.text = todoSections[indexPath.row]
        cell.TodoSectionLabel.textColor = UIColor.textColor
        cell.contentView.layer.cornerRadius = 25
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.backgroundColor = UIColor.backgroundColor
        cell.contentView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.contentView.layer.shadowRadius = 2.0
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        
//        cell.layer.applySketchShadow(color: UIColor.textColor, alpha: 0.1, x: 0, y: 3, blur: 13, spread: 4
//        )
        
        return cell

    }
    
// MARK: Segue Methods
    
    func projectSelected(sender: ProjectTableView) {
        //self.performSegue(withIdentifier: "ProjectDetail", sender: self)
        //let project: ProjectEntity
        if let indexPath = myTableView.indexPathForSelectedRow {
            let project = projectTableView.tableViewData[indexPath.row]
            let vc = ProjectTaskViewController(nibName: "TaskTableViewController", bundle: nil, project: project)
            vc.presentationController?.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.presentationController?.delegate = self
        
        if segue.identifier == "InboxDetail" {
            //            let destinationVC = segue.destination as? InboxViewController
        }
        else if segue.identifier == "TodayDetail"{
            //            let destinationVC = segue.destination as? TodayViewController
        }
        else if segue.identifier == "UpcomingDetail"{
            //            let destinationVC = segue.destination as? UpcomingViewController
        }
        else if segue.identifier == "HabitDetail"{
            
        }
        else if segue.identifier == "ProjectDetail" {
            let projectTaskVC = segue.destination as! ProjectTaskViewController
            
            if let indexPath = myTableView.indexPathForSelectedRow {
                let project = projectTableView.tableViewData[indexPath.row]
                projectTaskVC.project = project
            }
        }
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        collectionView.reloadData()
        smoothlyDeselectRows(tableView: myTableView)
        
    }
    
    
    override func viewDidLoad() {
        
        myTableView.layer.backgroundColor = UIColor.clear.cgColor
        
        
        
        self.view.backgroundColor = .BackgroundColor
    

        collectionView.delegate = self
        collectionView.dataSource = self
    
        projectTableView = ProjectTableView(myTableView)
        
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        myTableView.reloadData()
        super.viewWillAppear(animated)
        
        if let selectedRow: IndexPath = myTableView.indexPathForSelectedRow {
            myTableView.deselectRow(at: selectedRow, animated: true)
        }
        
    }
}
