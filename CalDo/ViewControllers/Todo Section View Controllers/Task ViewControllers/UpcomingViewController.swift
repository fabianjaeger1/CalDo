//
//  UpcomingViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 8/25/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class UpcomingViewController: TaskTableViewController {
        
    override func viewDidLoad() {
        predicate = NSPredicate(format: "(completed == false) AND (date != nil)")
        
        titleLabel.text = "Upcoming"
        
        let imageView = UIImageView(image: UIImage(named: "Scheduled"))
        imageView.frame = titleIcon.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleIcon.addSubview(imageView)
        
        super.viewDidLoad()
    }
}
