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



class ProjectTableView: NSObject, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate {
    
    
    func toggleSection(header: ProjectExpandableHeaderView, section: Int) {
        
        if isCollapsed == true {
            isCollapsed = false
        }
        else {
            isCollapsed = true
        }
        tableView.reloadSections(int)
    }
    
    
    

    var tableView: UITableView
    var tableViewData: [ProjectEntity]
    
    var isCollapsed: Bool
    
    
    
    weak var delegate: ProjectTableViewDelegate?

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
        self.isCollapsed = false
        super.init()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .BackgroundColor

        // Register all of your cells
        tableView.register(UINib(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
        tableView.register(ProjectExpandableHeaderView.nib, forHeaderFooterViewReuseIdentifier: ProjectExpandableHeaderView.identifier)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCollapsed == true {
            return 0
        }
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProjectExpandableHeaderView.identifier) as? ProjectExpandableHeaderView {
            headerView.section = section
            headerView.headerLabel.text = "Projects"
            headerView.image.image = UIImage(named: "ProjectImageLabel")
            headerView.delegate = self
            return headerView
        }
        return UIView()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.projectSelected(sender: self)
    }
    
}

@objc protocol ProjectTableViewDelegate: class {
    func projectSelected(sender: ProjectTableView)
}
