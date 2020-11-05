//
//  TagTaskViewController.swift
//  CalDo
//
//  Created by Nathan Baudis  on 9/14/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import Foundation
import UIKit

class TagTaskViewController: TaskTableViewController {
    var tag: TagEntity!
        
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, tag: TagEntity) {
        self.tag = tag
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        predicate = NSPredicate(format: "(completed == false) AND (%@ IN tags)", tag)
        // TODO: introduce custom sorting order for task?
        sortVariable = "allOrder"
        titleLabel.text = tag.value(forKey: "title") as? String

        let tagColor = UIColor(hexFromString: tag.value(forKey: "color") as! String)
        
        let tagImage = UIImage(systemName: "tag")?.withTintColor(tagColor, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: tagImage)
        imageView.frame = titleIcon.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleIcon.addSubview(imageView)
        
        // titleLabelLeadingConstraint.constant = 4
        
        super.viewDidLoad()
    }
}

