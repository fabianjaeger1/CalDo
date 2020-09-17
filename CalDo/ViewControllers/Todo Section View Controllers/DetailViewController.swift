//
//  DetailViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 9/11/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var todoTitle: UILabel!
    @IBOutlet weak var todoButton: UIButton!
    
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var projectColor: UIView!
    
    @IBOutlet weak var todoDate: UILabel!
    
    var task: TaskEntity!
    var indexPath: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        todoTitle.text = task.value(forKey: "title") as? String
        
        let project = task.value(forKey: "project")
        let projectColor = (project as? ProjectEntity)?.value(forKey: "color")
        
        projectTitle.text = (project as? ProjectEntity)?.title ?? "Inbox"
        if projectColor != nil {
             projectTitle.textColor = UIColor(hexString: (projectColor as! String))
        }
       
        let taskHasTime = task.value(forKey: "dateHasTime") as! Bool
        let date = task.value(forKey: "date") as? Date
        todoDate.text = date?.todoString(withTime: taskHasTime) ?? "No Date"
        todoDate.textColor = date?.todoColor(withTime: taskHasTime) ?? .systemGray
        
        self.view.backgroundColor = .BackgroundColor
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, task: TaskEntity, indexPath: IndexPath) {
        self.task = task
        self.indexPath = indexPath
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func completeButtonTapped(sender: UIButton!) {
        
        task.setValue(true, forKey: "completed")
        CoreDataManager.shared.saveContext()
        
        if presentationController is DetailPresentationController {
            (presentationController as!
                DetailPresentationController).detailDelegate?.drawerMovedTo(position: .closed)
            (presentationController as!
                DetailPresentationController).detailDelegate?.completeTaskInDetail(task, indexPath: self.indexPath)
        }
        
        self.dismiss(animated: true)
    }
    

}


