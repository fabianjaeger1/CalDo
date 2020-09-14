//
//  TaskTableViewController.swift
//  CalDo
//
//  Created by Nathan Baudis  on 8/24/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit
import CoreData


class TaskTableViewController: UIViewController {
    
    @IBOutlet var toolbarView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet var titleIcon: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet var editToolbar: UIToolbar!
    
    @IBOutlet weak var myTableView: UITableView!
    var taskTableView: TaskTableView!
    
    // Predicate to fetch tasks
    var predicate: NSPredicate!
    
    var realIsEditing: Bool = false
    
//    @IBAction func plusButtonPressed(_ sender: Any) {
//        addTaskTextField.becomeFirstResponder()
//    }
    
//    init(bundle nibBundleOrNil: Bundle?, predicate: NSPredicate) {
//        self.predicate = predicate
//        super.init(nibName: "TaskTableViewController", bundle: nibBundleOrNil)
//    }
//
//    required init?(coder: NSCoder) {
//        //fatalError("init(coder:) has not been implemented")
//        //return nil
//        super.init(coder: coder)
//    }
    
    // MARK: - Action Sheet
    
    
    @objc func tapCancelButton() {
        self.myTableView.setEditing(false, animated: true)
        self.realIsEditing = false
        
        UIView.transition(with: self.addButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.addButton.isHidden = false
        })
        
        UIView.transition(with: self.editToolbar, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.editToolbar.isHidden = true
        })
    }

    
    @IBAction func showActionSheet(_ sender : AnyObject) {
        // Print out what button was tapped
        func printActionTitle(_ action: UIAlertAction) {
            print("You tapped \(action.title!)")
        }

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let sortController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Sorting actions
        let sortByDateAction = UIAlertAction(title: "Sort by date", style: .default) { _ in
            let tasksBeforeSort = self.taskTableView.tableViewData
            let numberOfTasks = tasksBeforeSort.count
            
            self.taskTableView.tableViewData.sortByDate()

            self.taskTableView.tableView.performBatchUpdates({
                for i in 0..<numberOfTasks {
                    let newRow = self.taskTableView.tableViewData.firstIndex(of: tasksBeforeSort[i])
                    self.taskTableView.tableView.moveRow(at: IndexPath(row: i, section: 0), to: IndexPath(row: newRow!, section: 0))
                }
            })
        }
        sortByDateAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let sortByTitleAction = UIAlertAction(title: "Sort by title", style: .default) { _ in
            let tasksBeforeSort = self.taskTableView.tableViewData
            let numberOfTasks = tasksBeforeSort.count
            
            self.taskTableView.tableViewData.sortByTitle()
            
            self.taskTableView.tableView.performBatchUpdates({
                for i in 0..<numberOfTasks {
                    let newRow = self.taskTableView.tableViewData.firstIndex(of: tasksBeforeSort[i])
                    self.taskTableView.tableView.moveRow(at: IndexPath(row: i, section: 0), to: IndexPath(row: newRow!, section: 0))
                }
            })
            
        }
        sortByTitleAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let sortByPriorityAction = UIAlertAction(title: "Sort by priority", style: .default) { _ in
            let tasksBeforeSort = self.taskTableView.tableViewData
            let numberOfTasks = tasksBeforeSort.count
            
            self.taskTableView.tableViewData.sortByPriority()
            
            self.taskTableView.tableView.performBatchUpdates({
                for i in 0..<numberOfTasks {
                    let newRow = self.taskTableView.tableViewData.firstIndex(of: tasksBeforeSort[i])
                    self.taskTableView.tableView.moveRow(at: IndexPath(row: i, section: 0), to: IndexPath(row: newRow!, section: 0))
                }
            })
            
        }
        sortByPriorityAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        

        sortByDateAction.setValue(UIImage(systemName: "calendar"), forKey: "image")
        sortByTitleAction.setValue(UIImage(systemName: "textformat"), forKey: "image")
        sortByPriorityAction.setValue(UIImage(systemName: "flag"), forKey: "image")
            
        sortController.addAction(sortByTitleAction)
        sortController.addAction(sortByDateAction)
        sortController.addAction(sortByPriorityAction)
        sortController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Top-level actions
        let selectAction = UIAlertAction(title: "Select Tasks", style: .default) { _ in
            self.realIsEditing = true
            self.myTableView.setEditing(true, animated: true)
            
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.tapCancelButton))

            self.editToolbar.setItems([cancelButton], animated: false)
            
//            UIView.animate(withDuration: 0.5) {
////                self.editToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
////                self.editToolbar.sizeToFit()
////                self.editToolbar.translatesAutoresizingMaskIntoConstraints = false
////                self.view.addSubview(self.editToolbar)
////                self.view.bottomAnchor.constraint(equalTo: self.editToolbar.bottomAnchor).isActive = true
////                self.editToolbar.heightAnchor.constraint(equalToConstant: 100).isActive = true
////                self.myTableView.bottomAnchor.constraint(equalTo: self.editToolbar.topAnchor).isActive = true
//
//                // self.editToolbar.isTranslucent = false
//
//                self.editToolbar.isHidden = false
//
//                self.addButton.isHidden = true
//            }
            
            UIView.transition(with: self.addButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.addButton.isHidden = true
            })
            
            UIView.transition(with: self.editToolbar, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.editToolbar.isHidden = false
            })
            
            
//            let navigationController = UINavigationController(rootViewController: self)
//            navigationController.setToolbarHidden(false, animated: true)

        }
        selectAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        selectAction.setValue(UIImage(systemName: "square.stack"), forKey: "image")
        
        let filterAction = UIAlertAction(title: "Filter", style: .default)
        filterAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        filterAction.setValue(UIImage(systemName: "tag"), forKey: "image")
        
        let sortAction = UIAlertAction(title: "Sort Tasks", style: .default, handler: { _ in self.present(sortController, animated: true, completion: nil)
        })
        sortAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        sortAction.setValue(UIImage(systemName: "arrow.up.arrow.down"), forKey: "image")
        
        alertController.addAction(filterAction)
        alertController.addAction(selectAction)
        alertController.addAction(sortAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: printActionTitle))
        
        alertController.view.tintColor = .label
        sortController.view.tintColor = .label
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - View Setup
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        
        if traitCollection.userInterfaceStyle == .light {
       //     self.menuButton.setImage(UIImage(named: "Down_bright"), for: .normal)
        }

        // Menu Buttonn
        let configuration = UIImage.SymbolConfiguration(pointSize: 50)
        let menuButtonImage = UIImage(systemName: "ellipsis.circle", withConfiguration: configuration)
        menuButton.setImage(menuButtonImage, for: .normal)
        //menuButton.imageView?.contentMode = .scaleAspectFit
        // TODO: change highlight color of button
        menuButton.tintColor = .label
        menuButton.addTarget(self, action: #selector(self.showActionSheet(_:)), for: .touchUpInside)

        // Table View
        taskTableView = TaskTableView(myTableView, predicate)
        taskTableView.myViewController = self
        myTableView.allowsMultipleSelectionDuringEditing = true
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .BackgroundColor
        myTableView.backgroundView = backgroundView
        
        // Search Bar
        myTableView.tableHeaderView = taskTableView.searchController.searchBar
        navigationItem.searchController = taskTableView.searchController
        definesPresentationContext = true
        //myTableView.contentOffset = taskTableView.searchController.searchBar.bounds.height

        // Add Button
        let addButtonImage = UIImage(named: "Plus Sign")
        addButton.setImage(addButtonImage, for: .normal)
        
        //toolbarView.backgroundColor = .BackgroundColor
        myTableView.backgroundColor = .BackgroundColor
        self.view.backgroundColor = .BackgroundColor
        
        titleLabel.textColor = UIColor.textColor
        
        super.viewDidLoad()
        
        
        //toolbarView.layer.cornerRadius = 20
    }
    
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

