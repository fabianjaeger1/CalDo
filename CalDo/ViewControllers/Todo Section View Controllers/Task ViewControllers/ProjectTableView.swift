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

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}



class ProjectTableView: NSObject, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate {
    
    var tableView: UITableView
    var tableViewData: [ProjectEntity]
    var tagViewData: [TagEntity]
    
    var isCollapsedProject: Bool
    var isCollapsedTags: Bool
    
    weak var delegate: ProjectTableViewDelegate?
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        
        if section == 0  {
            header.setCollapsed(collapsed: isCollapsedProject)
            
            if isCollapsedProject {
                tableView.beginUpdates()
                let indexPaths = (0 ..< tableViewData.count)
                .map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .fade)
                isCollapsedProject = !isCollapsedProject
                tableView.endUpdates()
            }
            else {
                tableView.beginUpdates()
                let indexPaths = (0 ..< tableViewData.count)
                .map { IndexPath(row: $0, section: 0) }
                tableView.deleteRows(at: indexPaths, with: .fade)
                isCollapsedProject = !isCollapsedProject
                tableView.endUpdates()
            }
        }
        if section == 1  {
            header.setCollapsed(collapsed: isCollapsedTags)
            
            if isCollapsedTags {
                tableView.beginUpdates()
                let indexPaths = (0 ..< tableViewData.count)
                .map { IndexPath(row: $0, section: 1) }
                tableView.insertRows(at: indexPaths, with: .fade)
                isCollapsedTags = !isCollapsedTags
                tableView.endUpdates()
            }
            else {
                tableView.beginUpdates()
                let indexPaths = (0 ..< tagViewData.count)
                .map { IndexPath(row: $0, section: 1) }
                tableView.deleteRows(at: indexPaths, with: .fade)
                isCollapsedTags = !isCollapsedTags
                tableView.endUpdates()
            }
        }
    }
   
//        tableView.reloadSections(IndexSet(integer: section), with: .none)
    

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
        
        let request1 : NSFetchRequest<TagEntity> = TagEntity.fetchRequest()
        do {
            self.tagViewData = try managedContext.fetch(request1)
        } catch {
            print("Error fetching tags from context \(error)")
            return nil
        }
        self.isCollapsedProject = false
        self.isCollapsedTags = false
        super.init()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .BackgroundColor

        // Register all of your cells
        tableView.register(UINib(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
        tableView.register(UINib(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: "TagTableViewCell")
        tableView.register(ExpandableHeaderView.nib, forHeaderFooterViewReuseIdentifier: ExpandableHeaderView.identifier)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if isCollapsedProject == true {
                return 0
            }
            return tableViewData.count
        }
        if section == 1 {
            if isCollapsedTags == true {
                return 0
            }
            return tagViewData.count
        }
        return 0
    }
    
    // MARK: - Header View
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExpandableHeaderView.identifier) as? ExpandableHeaderView {
            if section == 0 {
                if isCollapsedProject == false {
                    headerView.view.backgroundColor = UIColor.backgroundColor
                }
                else {
                    headerView.view.backgroundColor = UIColor.BackgroundColor
                    headerView.arrowImage.transform = headerView.arrowImage.transform.rotated(by: -.pi/2)
                }
                headerView.view.layer.cornerRadius = 15
                headerView.section = section
                headerView.headerLabel.text = "Projects"
                headerView.image.image = UIImage(named: "ProjectImageLabel")
                headerView.arrowImage.image = UIImage(systemName: "chevron.down.circle")
                headerView.arrowImage.tintColor = UIColor.white
                headerView.delegate = self
                return headerView
            }
            if section == 1 {
                if isCollapsedTags == false {
                    headerView.view.backgroundColor = UIColor.backgroundColor
                }
                else{
                    headerView.view.backgroundColor = UIColor.BackgroundColor
                    headerView.arrowImage.transform = headerView.arrowImage.transform.rotated(by: -.pi/2)
                }
                headerView.view.layer.cornerRadius = 15
                headerView.section = section
                headerView.headerLabel.text = "Tags"
                headerView.image.image = UIImage(named: "TagImageIcon")
                headerView.arrowImage.image = UIImage(systemName: "chevron.down.circle")
                headerView.arrowImage.tintColor = UIColor.white
                headerView.delegate = self
                return headerView
            }
        }
        return UIView()
    }
    
    // MARK: - Cell

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let project = tableViewData[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as! ProjectTableViewCell
            cell.projectColor.layer.backgroundColor = UIColor.white.cgColor
       
            let projectTitle = project.value(forKey: "title") as! String
            let projectColor = UIColor(hexFromString: project.value(forKey: "color") as! String)
            
            cell.projectLabel.text = projectTitle
            cell.projectLabel.textColor = UIColor.textColor
            cell.projectColor.backgroundColor = projectColor
//            cell.tagIcon.image = nil
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.backgroundColor = UIColor.clear.cgColor

            let center = CGPoint(x: cell.projectColor.frame.height/2, y: cell.projectColor.frame.width/2)
            let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(4), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)

            shapeLayer.path = circlePath.cgPath
            shapeLayer.lineWidth = 3.0
            shapeLayer.fillColor = projectColor.cgColor

            cell.projectColor.layer.backgroundColor = UIColor.clear.cgColor
            cell.projectColor.layer.addSublayer(shapeLayer)
            
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.section == 1 {
            let tag = tagViewData[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
//            if let sublayer = cell.projectColor.layer.sublayers {
//                for layer in sublayer {
//                    layer.backgroundColor = UIColor.clear.cgColor
//                }
//            }
//            cell.projectColor.layer.backgroundColor = UIColor.BackgroundColor.cgColor
            let tagTitle = tag.value(forKey: "title") as! String
            let tagColor = UIColor(hexFromString: tag.value(forKey: "color") as! String)
            cell.tagIcon.image = UIImage(systemName: "tag.fill")?.withTintColor(tagColor, renderingMode: .alwaysOriginal)
//            cell.projectColor.backgroundColor = .clear
            
            
//            let tagIcon = UIImage(systemName: "tag.fill")?.withTintColor(tagColor, renderingMode: .alwaysOriginal)
//            let tagView = UIImageView(image: tagIcon!)
//            tagView.center = CGPoint(x: cell.projectColor.bounds.size.width / 2,
//                                     y: cell.projectColor.bounds.size.height / 2)
//            tagView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            cell.projectColor.addSubview(tagView)
//            cell.projectColor.bringSubviewToFront(tagView)
            
            cell.tagTitle.text = tagTitle
            cell.tagTitle.textColor = UIColor.textColor
//            cell.projectLabel.text = tagTitle
//            cell.projectLabel.textColor = UIColor.textColor
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.projectSelected(sender: self)
    }
    
    
}

@objc protocol ProjectTableViewDelegate: class {
    func projectSelected(sender: ProjectTableView)
}
