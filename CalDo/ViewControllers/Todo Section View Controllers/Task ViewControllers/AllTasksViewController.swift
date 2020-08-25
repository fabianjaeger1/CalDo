//
//  HabitViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 5/11/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit
import CoreData


//class GenericDataSource: NSObject {
//
//let identifier     = "CellId"
//var array: [Any]           = []
//
//func registerCells(forTableView tableView: UITableView) {
//    tableView.register(UINib(nibName: "", bundle: nil), forCellReuseIdentifier: identifier)
//  }
//
//func loadCell(atIndexPath indexPath: IndexPath, forTableView tableView: UITableView) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
//    return cell
//  }
//}
//
//// UITableViewDataSource
//extension GenericDataSource: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return array.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return self.loadCell(atIndexPath: indexPath, forTableView: tableView)
//    }
//
//}
//// UITableViewDelegate
//extension GenericDataSource: UITableViewDelegate {
//
//        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//            return UITableView.automaticDimension
//        }
//
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return UITableView.automaticDimension
//        }
//
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)      {
//
//        }
//}

protocol GenericDataSourceDelegate: class {
            // Delegate callbacks methods
}

class AllTasksViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var allTasksTableView: TaskTableView!
    
    
    override func viewDidLoad() {
        myTableView.backgroundColor = .BackgroundColor
        myTableView.layer.backgroundColor = UIColor.BackgroundColor.cgColor
        self.view.backgroundColor = .BackgroundColor
        
        
        let predicate = NSPredicate(format: "(completed == false)")
        allTasksTableView = TaskTableView(myTableView, predicate)
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
