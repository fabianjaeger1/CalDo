//
//  HabitViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 5/11/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

protocol GenericDataSourceDelegate: class {
            // Delegate callbacks methods
}

class AllTasksViewController: TaskTableViewController {
        override func viewDidLoad() {
        predicate = NSPredicate(format: "(completed == false)")
        
        titleLabel.text = "All Tasks"
        
        let imageView = UIImageView(image: UIImage(named: "All_Tasks"))
        imageView.frame = titleIcon.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleIcon.addSubview(imageView)
        
        super.viewDidLoad()
    }
}


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

