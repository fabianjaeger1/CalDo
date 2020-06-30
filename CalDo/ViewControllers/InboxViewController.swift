//
//  FirstViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 09.10.17.
//  Copyright © 2017 CalDo. All rights reserved.
//

import UIKit
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

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}



func computeNewDate(from fromDate: Date, to toDate: Date) -> Date {
     let delta = toDate - fromDate // `Date` - `Date` = `TimeInterval`
     let today = Date()
     if delta < 0 {
         return today
     } else {
         return today + delta // `Date` + `TimeInterval` = `Date`
     }
}

func DateToString(date:Date) -> String {
    let cal = Calendar.current

    let timeformatter = DateFormatter()
    timeformatter.dateFormat = "HH:mm"
    let time = timeformatter.string(from: date)
    
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "EEEE"
    
    let dateformatter2 = DateFormatter()
    dateformatter2.dateFormat = "d MMM HH:mm"

    let date1 = cal.startOfDay(for: Date())
    let date2 = cal.startOfDay(for: date)

    let components2 = cal.dateComponents([.day], from: date1, to: date2)
    
    if Calendar.current.isDateInToday(date){
        return "Today " + time
    }
    if Calendar.current.isDateInTomorrow(date){
        return "Tomorrow " + time
    }
    if Calendar.current.isDateInYesterday(date){
        return "Yesterday " + time
    }
    if components2.day! > 2 && components2.day! < 7 {
        return "\(dateformatter.string(from: date)) \(time)"
    }
    if components2.day! > 7{
        return dateformatter2.string(from: date)
    }
    
    return date.DatetoString(dateFormat: "MMM d yyyy HH:mm" )
}


var InboxTodo = [TodoItem]() //Globally defined variable for Todo items in Inbox

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ToDoCellDelegate {
    
    @IBOutlet var toolbarView: UIView!
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var AddTaskTextField: UITextField!
    
    @IBAction func PlusButtonPressed(_ sender: Any) {
        AddTaskTextField.becomeFirstResponder()
    }
    
    
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
        return InboxTodo.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithIcon", for: indexPath) as! InboxTableViewCell
        
        let shapeLayer = CAShapeLayer()
        let todo = InboxTodo[indexPath.row]
        // let ConvertedDate = todo.todoDate?.DatetoString(dateFormat: "HH:mm")

        let center = CGPoint(x: cell.ProjectColor.frame.height/2, y: cell.ProjectColor.frame.width/2)
        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(4), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)

        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 3.0


        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 3.0
        shapeLayer.fillColor = UIColor(hexString: (todo.todoProject?.ProjectColor)!).cgColor
        cell.ProjectColor.layer.backgroundColor = UIColor.clear.cgColor
        cell.ProjectColor.layer.addSublayer(shapeLayer)

        
        if todo.todoCompleted == true{
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
        cell.TodoTitle?.text = todo.todoTitle
        cell.TodoTitle.textColor = UIColor.textColor
        cell.TodoDate.textColor = UIColor.textColor
        cell.ProjectLabel.textColor = UIColor.textColor
        cell.TodoDate?.text = DateToString(date: todo.todoDate!)
        cell.ProjectLabel.text = todo.todoProject?.ProjectTitle
        cell.backgroundColor = .BackgroundColor
  
// ====================== TAGS ================================
        
        if todo.todoTags!.isEmpty {
        }
        else{
            let count = todo.todoTags!.count
            if count == 1 {
                cell.Tag1.text = todo.todoTags![0].tagLabel!
                cell.Tag1.textColor = todo.todoTags![0].tagColor!
            }
            else if count == 2{
                cell.Tag1.text = todo.todoTags![0].tagLabel!
                cell.Tag1.textColor = todo.todoTags![0].tagColor!
                cell.Tag2.text = todo.todoTags![1].tagLabel!
                cell.Tag2.textColor = todo.todoTags![1].tagColor!
            }
            else if count == 3{
                cell.Tag1.text = todo.todoTags![0].tagLabel!
                cell.Tag1.textColor = todo.todoTags![0].tagColor!
                cell.Tag2.text = todo.todoTags![1].tagLabel!
                cell.Tag2.textColor = todo.todoTags![1].tagColor!
                cell.Tag3.text = todo.todoTags![2].tagLabel!
                cell.Tag3.textColor = todo.todoTags![2].tagColor!
            }
            else if count == 4{
                cell.Tag1.text = todo.todoTags![0].tagLabel!
                cell.Tag1.textColor = todo.todoTags![0].tagColor!
                cell.Tag2.text = todo.todoTags![1].tagLabel!
                cell.Tag2.textColor = todo.todoTags![1].tagColor!
                cell.Tag3.text = todo.todoTags![2].tagLabel!
                cell.Tag3.textColor = todo.todoTags![2].tagColor!
                cell.Tag4.text = todo.todoTags![3].tagLabel!
                cell.Tag4.textColor = todo.todoTags![3].tagColor!
            }
            else if count == 5{
                cell.Tag1.text = todo.todoTags![0].tagLabel!
                cell.Tag1.textColor = todo.todoTags![0].tagColor!
                cell.Tag2.text = todo.todoTags![1].tagLabel!
                cell.Tag2.textColor = todo.todoTags![1].tagColor!
                cell.Tag3.text = todo.todoTags![2].tagLabel!
                cell.Tag3.textColor = todo.todoTags![2].tagColor!
                cell.Tag4.text = todo.todoTags![3].tagLabel!
                cell.Tag4.textColor = todo.todoTags![3].tagColor!
                cell.Tag5.text = todo.todoTags![4].tagLabel!
                cell.Tag5.textColor = todo.todoTags![4].tagColor!
            }
        }
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
// =============== CELL ICONS =======================
        if todo.todoNotes != nil{
            cell.TodoNotesIcon.alpha = 1
        }
        else {
            cell.TodoNotesIcon.alpha = 0
        }
        
        if todo.todoLocation == nil{
            cell.TodoLocationIcon.alpha = 0
        }
        else{
            cell.TodoLocationIcon.alpha = 1
        }
// ================== CELL TODO BUTTON =======================
        
        if todo.todoRecurrence == true && todo.todoPriority == [2]{
            let image = UIImage(named: "Recurring Normal")
            cell.TodoStatus.setImage(image, for: .normal)
        }
        if todo.todoRecurrence == true && todo.todoPriority == [3]{
            let image = UIImage(named: "Recurring High")
            cell.TodoStatus.setImage(image, for: .normal)
        }
        
        if todo.todoPriority == [2] && todo.todoRecurrence != true {
            let image = UIImage(named: "Todo Medium Priority")
            cell.TodoStatus.setImage(image, for: .normal)
        }
        if todo.todoPriority == [3] && todo.todoRecurrence != true {
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
        
        
        toolbarView.backgroundColor = .BackgroundColor
        
        InboxLabel.textColor = UIColor.textColor
        SearchBar.barTintColor = UIColor.white
        SearchBar.isTranslucent = false
        SearchBar.tintColor = UIColor.blue
        myTableView.backgroundColor = .BackgroundColor
        
        self.view.backgroundColor = UIColor.BackgroundColor
        
        AddButton.createFloatingActionButton()
        
        super.viewDidLoad()
        
        textfield.inputAccessoryView = toolbarView
        
        toolbarView.layer.cornerRadius = 20
        

        
        // Load the view using bundle.
        // Make sure a nib name should be correct
        // And cast it to the class, something like this
       


        InboxTodo = TodoItem.loadSampleToDos()
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
//            var todo = InboxTodo[indexPath.row]
            var todo = InboxTodo[indexPath.row]

            todo.todoCompleted = !todo.todoCompleted
            InboxTodo[indexPath.row] = todo
            impact.impactOccurred()
            myTableView.reloadRows(at: [indexPath], with: .automatic)
                            InboxTodo.remove(at: indexPath.row)
            
            UIView.animate(withDuration: 0.8){
//                self.myTableView.deleteSections(at: [indexPath], with: .fade)
                self.myTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
//            myTableView.reloadData()
            
         
        
        }
    }
    
    
    
}

