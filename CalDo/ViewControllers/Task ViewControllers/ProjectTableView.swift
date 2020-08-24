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
        
        super.init()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .BackgroundColor

        // Register all of your cells
        tableView.register(UINib(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Projects"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
//
//                let label = UILabel()
//                label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//                label.text = "Projects"
//
//
//                headerView.addSubview(label)
//
//                return headerView
        
        let sectionButton = UIButton()
         
         // 2
         sectionButton.setTitle(String(section),
                                for: .normal)
         
         // 3
         sectionButton.backgroundColor = .systemBlue
         
         // 4
         sectionButton.tag = section
         
         // 5
         sectionButton.addTarget(self,
                                 action: #selector(self.hideSection(sender:)),
                                 for: .touchUpInside)

         return sectionButton
    }
//
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
      if let headerView = view as? UITableViewHeaderFooterView {
          headerView.contentView.backgroundColor = .clear
          headerView.backgroundView?.backgroundColor = .clear
          headerView.textLabel?.textColor = .textColor
        headerView.textLabel?.font = UIFont(name: "Avenir", size: 20)
      }
  }

}

@objc protocol ProjectTableViewDelegate: class {
    func projectSelected(sender: ProjectTableView)
}
