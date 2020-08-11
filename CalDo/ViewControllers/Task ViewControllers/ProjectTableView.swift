//
//  ProjectTableView.swift
//  CalDo
//
//  Created by Nathan Baudis on 11.08.20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProjectTableView: NSObject, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView
    var tableViewData: [ProjectEntity]

    init?(_ tv: UITableView) {
        
        tableView = tv
        
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let request : NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        do {
            self.tableViewData = try managedContext.fetch(request)
        } catch {
            print("Error fetching projects from context \(error)")
            return nil
        }
        
        super.init()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .BackgroundColor

        // Register all of your cells
        tableView.register(UINib(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = tableViewData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as! ProjectTableViewCell
        
        let projectTitle = project.value(forKey: "title") as! String
        let projectColor = UIColor(hexFromString: project.value(forKey: "color") as! String)
        
        // Set label
        cell.projectLabel.text = projectTitle
        cell.projectLabel.textColor = UIColor.textColor
        
        // Set color
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.clear.cgColor

        let center = CGPoint(x: cell.projectColor.frame.height/2, y: cell.projectColor.frame.width/2)
        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(4), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)

        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 3.0
        shapeLayer.fillColor = projectColor.cgColor

        cell.projectColor.layer.backgroundColor = UIColor.clear.cgColor
        cell.projectColor.layer.addSublayer(shapeLayer)
        
        return cell
    }

}
