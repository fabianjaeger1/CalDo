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

class InboxViewController: TaskTableViewController {
    
//    init(bundle nibBundleOrNil: Bundle?) {
//        let predicate = NSPredicate(format: "(completed == false)")
//        super.init(bundle: nibBundleOrNil, predicate: predicate)
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
//    convenience init() {
//        //predicate = NSPredicate(format: "(completed == false)")
//        self.init(nibName: "TaskTableViewController", bundle: nil)
//    }

    override func viewDidLoad() {
        predicate = NSPredicate(format: "(completed == false)")

        titleLabel.text = "Today"
        
        let imageView = UIImageView(image: UIImage(named: "Inbox_Home"))
        imageView.frame = titleIcon.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        //titleIcon.autoresizesSubviews = true
        titleIcon.addSubview(imageView)
        
        super.viewDidLoad()
    }

}

//class InboxViewController: UIViewController {
//
//    // Get the CoreData context
//    // let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    // var InboxTasks = [NSManagedObject]()
//    // var InboxTasks = loadSampleTaskEntities()
//
//    @IBOutlet var toolbarView: UIView!
//    @IBOutlet weak var textfield: UITextField!
//
//    @IBOutlet weak var addTaskTextField: UITextField!
//
//    @IBAction func plusButtonPressed(_ sender: Any) {
//        addTaskTextField.becomeFirstResponder()
//    }
//
//
//    // var myIndex = 0
//
//    @IBOutlet weak var addButton: UIButton!
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var inboxLabel: UILabel!
//    @IBOutlet weak var menuButton: UIButton!
//
//    @IBOutlet weak var editToolbar: UIToolbar!
//
//
//    @IBOutlet weak var myTableView: UITableView!
//    var inboxTableView: TaskTableView!
//
//
//    // MARK: - Action Sheet
//
//    @objc func tapCancelButton() {
//        self.myTableView.setEditing(false, animated: true)
//        self.editToolbar.isHidden = true
//    }
//
//    @IBAction func showActionSheet(_ sender : AnyObject) {
//        // Print out what button was tapped
//        func printActionTitle(_ action: UIAlertAction) {
//            print("You tapped \(action.title!)")
//        }
//
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let sortController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        // Sorting actions
//        let sortByDateAction = UIAlertAction(title: "Sort by date", style: .default) { _ in
//            let tasksBeforeSort = self.inboxTableView.tableViewData
//            let numberOfTasks = tasksBeforeSort.count
//
//            self.inboxTableView.tableViewData.sortByDate()
//
//            self.inboxTableView.tableView.performBatchUpdates({
//                for i in 0..<numberOfTasks {
//                    let newRow = self.inboxTableView.tableViewData.firstIndex(of: tasksBeforeSort[i])
//                    self.inboxTableView.tableView.moveRow(at: IndexPath(row: i, section: 0), to: IndexPath(row: newRow!, section: 0))
//                }
//            })
//        }
//        sortByDateAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
//
//        let sortByTitleAction = UIAlertAction(title: "Sort by title", style: .default) { _ in
//            let tasksBeforeSort = self.inboxTableView.tableViewData
//            let numberOfTasks = tasksBeforeSort.count
//
//            self.inboxTableView.tableViewData.sortByTitle()
//
//            self.inboxTableView.tableView.performBatchUpdates({
//                for i in 0..<numberOfTasks {
//                    let newRow = self.inboxTableView.tableViewData.firstIndex(of: tasksBeforeSort[i])
//                    self.inboxTableView.tableView.moveRow(at: IndexPath(row: i, section: 0), to: IndexPath(row: newRow!, section: 0))
//                }
//            })
//
//        }
//        sortByTitleAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
//
//        let sortByPriorityAction = UIAlertAction(title: "Sort by priority", style: .default) { _ in
//            let tasksBeforeSort = self.inboxTableView.tableViewData
//            let numberOfTasks = tasksBeforeSort.count
//
//            self.inboxTableView.tableViewData.sortByPriority()
//
//            self.inboxTableView.tableView.performBatchUpdates({
//                for i in 0..<numberOfTasks {
//                    let newRow = self.inboxTableView.tableViewData.firstIndex(of: tasksBeforeSort[i])
//                    self.inboxTableView.tableView.moveRow(at: IndexPath(row: i, section: 0), to: IndexPath(row: newRow!, section: 0))
//                }
//            })
//
//        }
//        sortByPriorityAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
//
//
//        sortByDateAction.setValue(UIImage(systemName: "calendar"), forKey: "image")
//        sortByTitleAction.setValue(UIImage(systemName: "textformat"), forKey: "image")
//        sortByPriorityAction.setValue(UIImage(systemName: "flag"), forKey: "image")
//
//        sortController.addAction(sortByTitleAction)
//        sortController.addAction(sortByDateAction)
//        sortController.addAction(sortByPriorityAction)
//        sortController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//
//        // Top-level actions
//        let selectAction = UIAlertAction(title: "Select Tasks", style: .default) { _ in
//            self.myTableView.setEditing(true, animated: true)
//            UIView.animate(withDuration: 0.5) {
//                self.editToolbar.isHidden = false
//            }
//            let verticalSpaceConstraint = NSLayoutConstraint(item: self.editToolbar!, attribute: .top, relatedBy: .equal, toItem: self.addButton, attribute: .bottom, multiplier: 1, constant: 20)
//            // NSLayoutConstraint.activate([verticalSpaceConstraint])
//            self.view.addConstraint(verticalSpaceConstraint)
//
//
//            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.tapCancelButton))
//
//
//
//            self.editToolbar.setItems([cancelButton], animated: true)
//
////            self.toolbarItems = [editButton]
////            self.navigationController?.setToolbarHidden(false, animated: true)
////            let navigationController = UINavigationController(rootViewController: self)
////            navigationController.setToolbarHidden(false, animated: true)
//
//        }
//        selectAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
//        selectAction.setValue(UIImage(systemName: "square.stack"), forKey: "image")
//
//        let filterAction = UIAlertAction(title: "Filter", style: .default)
//        filterAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
//        filterAction.setValue(UIImage(systemName: "tag"), forKey: "image")
//
//        let sortAction = UIAlertAction(title: "Sort Tasks", style: .default, handler: { _ in self.present(sortController, animated: true, completion: nil)
//        })
//        sortAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
//        sortAction.setValue(UIImage(systemName: "arrow.up.arrow.down"), forKey: "image")
//
//        alertController.addAction(filterAction)
//        alertController.addAction(selectAction)
//        alertController.addAction(sortAction)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: printActionTitle))
//
//        alertController.view.tintColor = .label
//        sortController.view.tintColor = .label
//
//        self.present(alertController, animated: true, completion: nil)
//    }
//
//
//    // MARK: - View Setup
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // inboxTableView.refreshTableViewData()
//        // inboxTableView.tableView.reloadData()
//    }
//
//    override func viewDidLoad() {
//
//        // TODO: unnecessary declaration every time?
//        let predicate = NSPredicate(format: "(completed == false)")
//        inboxTableView = TaskTableView(myTableView, predicate)
//
//        if traitCollection.userInterfaceStyle == .light {
//            self.menuButton.setImage(UIImage(named: "Down_bright"), for: .normal)
//        }
//
//        myTableView.allowsMultipleSelectionDuringEditing = true
//
//        toolbarView.backgroundColor = .BackgroundColor
//
//        inboxLabel.textColor = UIColor.textColor
//        searchBar.barTintColor = UIColor.white
//        searchBar.isTranslucent = false
//        searchBar.tintColor = UIColor.blue
//
//        myTableView.backgroundColor = .BackgroundColor
//        self.view.backgroundColor = .BackgroundColor
//
//        addButton.createFloatingActionButton()
//
//        super.viewDidLoad()
//
//        textfield.inputAccessoryView = toolbarView
//
//        toolbarView.layer.cornerRadius = 20
//
//        // Search bar
//        myTableView.tableHeaderView = inboxTableView.searchController.searchBar
//        navigationItem.searchController = inboxTableView.searchController
//        definesPresentationContext = true
//
//    }
//
//
//
//}


//extension InboxViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        filterTasksForSearchText(searchBar.text!)
//    }
//
//
//}


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
//    let cellSpacingHeight: CGFloat = 10

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
