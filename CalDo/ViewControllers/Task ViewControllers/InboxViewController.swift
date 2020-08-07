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



// Part 1: Data Model; Model is written and initialised -> Todo item
// In tutorial we have 3 different types, Profile, Friend and Attribute

// Part 2: View Model;


// var InboxTodo = [TodoItem]() // Globally defined variable for Todo items in Inbox

class InboxViewController: UIViewController {
    
    // Get the CoreData context
    // let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // var InboxTasks = [NSManagedObject]()
    // var InboxTasks = loadSampleTaskEntities()
  
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
    var inboxTableView: TaskTableView!
    
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
    
    

    
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        myTableView.reloadData()
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // CoreDataManager.shared.fetchInboxTasks()
        // ALLTASKS
        super.viewWillAppear(animated)
        
        CoreDataManager.shared.fetchAllTasks()
        
        inboxTableView = TaskTableView(myTableView, CoreDataManager.shared.allTasks)
        inboxTableView.tableView.reloadData()
        
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
       

        // Load tasks
        // loadSampleTaskEntities()
        // loadTasks()
        
        
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
    
    
    
    
    
}

