//
//  ProjectTaskViewController.swift
//  CalDo
//
//  Created by Nathan Baudis  on 8/11/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import Foundation
import UIKit


class ProjectTaskViewController: UIViewController {
    
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var projectColor: UIView!
    

    @IBOutlet weak var myTableView: UITableView!
    var projectTaskTableView: TaskTableView!
    var project: ProjectEntity!



    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        // todayTableView.tableView.reloadData()
    }

    override func viewDidLoad() {
        
        let predicate = NSPredicate(format: "(completed == false) AND (project == %@)", project)
        projectTaskTableView = TaskTableView(myTableView, predicate)
        
        projectLabel.text = project.value(forKey: "title") as? String
    }
    

}
