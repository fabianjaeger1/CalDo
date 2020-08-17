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
    
    @IBOutlet weak var addTaskTextField: UITextField!
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        addTaskTextField.becomeFirstResponder()
    }
    
    
    // var myIndex = 0
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var inboxLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var editToolbar: UIToolbar!
    
    
    @IBOutlet weak var myTableView: UITableView!
    var inboxTableView: TaskTableView!
    
    
    // MARK: - Action Sheet
    
    @objc func tapCancelButton() {
        self.myTableView.setEditing(false, animated: true)
        self.editToolbar.isHidden = true
    }
    
    @IBAction func showActionSheet(_ sender : AnyObject) {
        // Print out what button was tapped
        func printActionTitle(_ action: UIAlertAction) {
            print("You tapped \(action.title!)")
        }

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sortController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sortByDateAction = UIAlertAction(title: "Sort by date", style: .default) { _ in
            let tasksBeforeSort = self.inboxTableView.tableViewData
            let numberOfTasks = tasksBeforeSort.count
            
            self.inboxTableView.tableViewData.sortByDate()

            self.inboxTableView.tableView.performBatchUpdates({
                for i in 0..<numberOfTasks {
                    let newRow = self.inboxTableView.tableViewData.firstIndex(of: tasksBeforeSort[i])
                    self.inboxTableView.tableView.moveRow(at: IndexPath(row: i, section: 0), to: IndexPath(row: newRow!, section: 0))
                }
            })
        }
        sortByDateAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let sortByTitleAction = UIAlertAction(title: "Sort by title", style: .default) { _ in
            let tasksBeforeSort = self.inboxTableView.tableViewData
            let numberOfTasks = tasksBeforeSort.count
            
            self.inboxTableView.tableViewData.sortByTitle()
            
            self.inboxTableView.tableView.performBatchUpdates({
                for i in 0..<numberOfTasks {
                    let newRow = self.inboxTableView.tableViewData.firstIndex(of: tasksBeforeSort[i])
                    self.inboxTableView.tableView.moveRow(at: IndexPath(row: i, section: 0), to: IndexPath(row: newRow!, section: 0))
                }
            })
            
        }
        sortByTitleAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let sortByPriorityAction = UIAlertAction(title: "Sort by priority", style: .default) { _ in
            let tasksBeforeSort = self.inboxTableView.tableViewData
            let numberOfTasks = tasksBeforeSort.count
            
            self.inboxTableView.tableViewData.sortByPriority()
            
            self.inboxTableView.tableView.performBatchUpdates({
                for i in 0..<numberOfTasks {
                    let newRow = self.inboxTableView.tableViewData.firstIndex(of: tasksBeforeSort[i])
                    self.inboxTableView.tableView.moveRow(at: IndexPath(row: i, section: 0), to: IndexPath(row: newRow!, section: 0))
                }
            })
            
        }
        sortByPriorityAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        if #available(iOS 13.0, *) {
            sortByDateAction.setValue(UIImage(systemName: "calendar"), forKey: "image")
            sortByTitleAction.setValue(UIImage(systemName: "textformat"), forKey: "image")
            sortByPriorityAction.setValue(UIImage(systemName: "flag"), forKey: "image")
        } else {
            // Fallback on earlier versions
        }
        
        sortController.addAction(sortByTitleAction)
        sortController.addAction(sortByDateAction)
        sortController.addAction(sortByPriorityAction)
        sortController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.addAction(UIAlertAction(title: "Select Tasks", style: .default) { _ in
            self.myTableView.setEditing(true, animated: true)
            UIView.animate(withDuration: 0.5) {
                self.editToolbar.isHidden = false
            }
            let verticalSpaceConstraint = NSLayoutConstraint(item: self.editToolbar!, attribute: .top, relatedBy: .equal, toItem: self.addButton, attribute: .bottom, multiplier: 1, constant: 20)
            // NSLayoutConstraint.activate([verticalSpaceConstraint])
            self.view.addConstraint(verticalSpaceConstraint)
            

            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.tapCancelButton))
            

            
            self.editToolbar.setItems([cancelButton], animated: true)
            
//            self.toolbarItems = [editButton]
//            self.navigationController?.setToolbarHidden(false, animated: true)
//            let navigationController = UINavigationController(rootViewController: self)
//            navigationController.setToolbarHidden(false, animated: true)

        })
        
        
        alertController.addAction(UIAlertAction(title: "Filter", style: .default, handler: printActionTitle))
        alertController.addAction(UIAlertAction(title: "Sort Tasks", style: .default, handler: { _ in self.present(sortController, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Share Chat", style: .destructive, handler: printActionTitle))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: printActionTitle))
        
        // alertController.view.tintColor = .systemTeal
        // sortController.view.tintColor = .systemTeal
        
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
        super.viewWillAppear(animated)
        
        // inboxTableView.refreshTableViewData()
        // inboxTableView.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        // TODO: unnecessary declaration every time?
        let predicate = NSPredicate(format: "(completed == false)")
        inboxTableView = TaskTableView(myTableView, predicate)
        
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                self.menuButton.setImage(UIImage(named: "Down_bright"), for: .normal)
            }
        } else {
            // Fallback on earlier versions
        }
        
        myTableView.allowsMultipleSelectionDuringEditing = true
        
        toolbarView.backgroundColor = .BackgroundColor
        
        inboxLabel.textColor = UIColor.textColor
        searchBar.barTintColor = UIColor.white
        searchBar.isTranslucent = false
        searchBar.tintColor = UIColor.blue
        
        myTableView.backgroundColor = .BackgroundColor
        self.view.backgroundColor = .BackgroundColor
        
        addButton.createFloatingActionButton()
        
        super.viewDidLoad()
        
        textfield.inputAccessoryView = toolbarView
        
        toolbarView.layer.cornerRadius = 20

    }
    
    
    
    
}

