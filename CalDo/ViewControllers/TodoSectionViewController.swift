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

let todoSections = ["Inbox", "Today", "Next", "Habits"]


class TodoSectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIAdaptivePresentationControllerDelegate {
    
    // loadSampleTaskEntities()

//    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var myTableView: UITableView!
    var projectTableView: ProjectTableView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var myView: UIView!
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return allProjects!.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = projectTableView.dequeueReusableCell(withIdentifier: "TodoSectionProjectsTableViewCell", for: indexPath) as! TodoSectionProjectsTableViewCell
//
//
//        cell.ProjectLabel.text = allProjects![indexPath.row].ProjectTitle
//
//        let shapeLayer = CAShapeLayer()
//
//        let center = CGPoint(x: cell.ProjectColor.frame.height/2, y: cell.ProjectColor.frame.width/2)
//        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(6), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
//
//        shapeLayer.path = circlePath.cgPath
//        shapeLayer.lineWidth = 3.0
//
//
//        shapeLayer.path = circlePath.cgPath
//        shapeLayer.lineWidth = 3.0
//        shapeLayer.fillColor = UIColor(hexString: allProjects![indexPath.row].ProjectColor!).cgColor
//        cell.ProjectColor.layer.addSublayer(shapeLayer)
//        cell.ProjectLabel.textColor = UIColor.textColor
//        cell.backgroundColor = UIColor.BackgroundColor
//        return cell
//    }
    
    
    
// ============================== COLLECTION VIEW ==============================================
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todoSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath == NSIndexPath(row: 0, section: 0) as IndexPath{
            self.performSegue(withIdentifier: "InboxDetail", sender: self)
        }
        if indexPath == NSIndexPath(row: 1, section: 0) as IndexPath{
            self.performSegue(withIdentifier: "TodayDetail", sender: self)
        }
        if indexPath == NSIndexPath(row: 2, section: 0) as IndexPath{
            self.performSegue(withIdentifier: "UpcomingDetail", sender: self)
        }
        if indexPath == NSIndexPath(row: 3, section: 0) as IndexPath{
            self.performSegue(withIdentifier: "HabitDetail", sender: self)
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
            cell.TodoSection.image = UIImage(named: "Habits_Home")
        default:
            print("Bad indexPath for TodoSection CollectionView")
        }
        
        cell.layer.cornerRadius = 25
        
        cell.TodoAmountLabel.textColor = UIColor.textColor
        cell.TodoSectionLabel.text = todoSections[indexPath.row]
        cell.TodoSectionLabel.textColor = UIColor.textColor
        
        cell.contentView.layer.cornerRadius = 25
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.backgroundColor = UIColor.backgroundColor
//        cell.contentView.layer.masksToBounds = false;
        cell.contentView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.contentView.layer.shadowRadius = 2.0
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowRadius = 2.0
    
        
        // Need for implementation of shadows here
    
        
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        
//        cell.layer.applySketchShadow(color: UIColor.textColor, alpha: 0.1, x: 0, y: 3, blur: 13, spread: 4
//        )
        
        return cell

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
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        collectionView.reloadData()
    }
    
    
// ================ Old TableView =================
    
    let cellSpacingHeight: CGFloat = 20
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoSectionCell", for: indexPath) as! TodoSectionsTableViewCell
//        cell.TodoLabel.text = TodoSections[indexPath.section]
//
//        let InboxImage = UIImage(named: "Inbox")
//        let TodayImage = UIImage(named: "Today")
//        let UpcomingImage = UIImage(named: "Upcoming")
//        let HabitImage = UIImage(named: "Habits")
//        let imageArray = [InboxImage,TodayImage,UpcomingImage,HabitImage]
//
//        cell.TodoImage.image = imageArray[indexPath.section]
//
//        return cell
//    }
    
 
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if  segue.identifier == blogSegueIdentifier,
//            let destination = segue.destination as? BlogViewController,
//            let blogIndex = tableView.indexPathForSelectedRow?.row
//        {
//            destination.blogName = swiftBlogs[blogIndex]
//        }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        cell.layer.cornerRadius = 20
////        cell.layer.backgroundColor = UIColor(hexString: "F0F2F4").cgColor
//
//        cell.layer.masksToBounds = false
//        cell.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6)
//
    
// ============ SHADOWS ================
//        cell.layer.shadowOpacity = 0.20
//        cell.layer.shadowRadius = 10
//        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cell.layer.shadowColor = UIColor.gray.cgColor
//        cell.layer.backgroundColor = UIColor.white.cgColor
//
//    }
    

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return TodoSections.count
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return cellSpacingHeight
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath == NSIndexPath(row: 0, section: 0) as IndexPath{
//            self.performSegue(withIdentifier: "InboxDetail", sender: self)
//        }
//        if indexPath == NSIndexPath(row: 0, section: 1) as IndexPath{
//            self.performSegue(withIdentifier: "TodayDetail", sender: self)
//        }
//        if indexPath == NSIndexPath(row: 0, section: 2) as IndexPath{
//            self.performSegue(withIdentifier: "UpcomingDetail", sender: self)
//        }
//
//    }
    

    override func viewDidLoad() {
        
        myTableView.layer.backgroundColor = UIColor.clear.cgColor
        
        
        
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .BackgroundColor
        } else {
            // Fallback on earlier versions
        }
    

        collectionView.delegate = self
        collectionView.dataSource = self
        
//        projectTableView.delegate = self
//        projectTableView.dataSource = self
//        projectTableView.backgroundColor = .BackgroundColor
        
        projectTableView = ProjectTableView(myTableView)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        super.viewWillAppear(animated)
    }

    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }

}
