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

let TodoSections = ["Inbox", "Today", "Next", "Habits"]

var AllProjects: [Project]?

class TodoSectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // loadSampleTaskEntities()

//    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var ProjectTableView: UITableView!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AllProjects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProjectTableView.dequeueReusableCell(withIdentifier: "TodoSectionProjectsTableViewCell", for: indexPath) as! TodoSectionProjectsTableViewCell
        
        
        cell.ProjectLabel.text = AllProjects![indexPath.row].ProjectTitle
        
        let shapeLayer = CAShapeLayer()
        
        let center = CGPoint(x: cell.ProjectColor.frame.height/2, y: cell.ProjectColor.frame.width/2)
        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(6), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 3.0
        
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 3.0
        shapeLayer.fillColor = UIColor(hexString: AllProjects![indexPath.row].ProjectColor!).cgColor
        cell.ProjectColor.layer.addSublayer(shapeLayer)
        cell.ProjectLabel.textColor = UIColor.textColor
        cell.backgroundColor = UIColor.BackgroundColor
        return cell
    }
    
    
    
// ============================== COLLECTION VIEW ==============================================
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TodoSections.count
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
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "TodoSectionCollectionViewCell", for: indexPath) as! TodoSectionCollectionViewCell
    
        let InboxImage = UIImage(named: "Inbox_Home")
        let TodayImage = UIImage(named: "Today_Todo")
        let UpcomingImage = UIImage(named: "Scheduled")
        let HabitImage = UIImage(named: "Habits_Home")
        let imageArray = [InboxImage,TodayImage,UpcomingImage,HabitImage]
        
        cell.layer.cornerRadius = 25
        cell.TodoSection.image = imageArray[indexPath.row]
        cell.TodoSectionLabel.text = TodoSections[indexPath.row]
        cell.TodoAmountLabel.textColor = UIColor.textColor
        
        
        var todoAmountLabels = [String](repeating: "", count: 4)
        
        CoreDataManager.shared.fetchInboxTasks()
        let inboxTaskAmount = CoreDataManager.shared.inboxTasks.count
        if inboxTaskAmount == 1 {
            todoAmountLabels[0] = "1 Task"
        }
        else {
            todoAmountLabels[0] = "\(inboxTaskAmount) Tasks"
        }
        
        cell.TodoAmountLabel.text = todoAmountLabels[indexPath.row]
            
        cell.TodoSectionLabel.textColor = UIColor.textColor
//        cell.TodoAmountLabel.textColor = UIColor(hexString: "C6CCD4")
        
        cell.contentView.layer.cornerRadius = 20
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
        
        AllProjects = Project.loadProjects()
        
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .BackgroundColor
        } else {
            // Fallback on earlier versions
        }

        CollectionView.delegate = self
        CollectionView.dataSource = self
        
        ProjectTableView.delegate = self
        ProjectTableView.dataSource = self
        ProjectTableView.backgroundColor = .BackgroundColor
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }

}
