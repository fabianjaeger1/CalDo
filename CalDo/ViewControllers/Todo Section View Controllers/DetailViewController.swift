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
    
    // var task: TaskEntity

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        self.view.backgroundColor = .BackgroundColor

    }

    @objc func completeButtonTapped(sender: UIButton!) {
        
        if presentationController is DetailPresentationController {
            (presentationController as! DetailPresentationController).detailDelegate?.drawerMovedTo(position: .closed)
        }
        
        self.dismiss(animated: true)
    }
    

}


