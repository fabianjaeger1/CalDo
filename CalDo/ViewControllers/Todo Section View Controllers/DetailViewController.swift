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
    
    var task: TaskEntity!
    var indexPath: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
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


