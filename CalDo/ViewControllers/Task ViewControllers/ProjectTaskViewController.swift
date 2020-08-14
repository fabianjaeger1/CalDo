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
        
        // Set text
        projectLabel.text = project.value(forKey: "title") as? String
        
        // Set color
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.clear.cgColor

        let center = CGPoint(x: projectColor.frame.height/2, y: projectColor.frame.width/2)
        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(8), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)

        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 3.0
        shapeLayer.fillColor = UIColor(hexFromString: project.value(forKey: "color") as! String).cgColor

        projectColor.layer.backgroundColor = UIColor.clear.cgColor
        projectColor.layer.addSublayer(shapeLayer)
        
        // Background color
        myTableView.backgroundColor = .BackgroundColor
        self.view.backgroundColor = .BackgroundColor
        //self.
    }
    

}
