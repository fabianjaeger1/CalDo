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

@objc protocol ProjectTableViewDelegate: class {
    func projectSelected(sender: ProjectTableView)
    func tagSelected(sender: ProjectTableView)
    func reloadCollection(sender: ProjectTableView)
}



class ProjectTableView: NSObject, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate {
    
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
                tableView.insertRows(at: indexPaths, with: .top)
                isCollapsedProject = !isCollapsedProject
                tableView.endUpdates()
            }
            else {
                tableView.beginUpdates()
                let indexPaths = (0 ..< tableViewData.count)
                .map { IndexPath(row: $0, section: 0) }
                tableView.deleteRows(at: indexPaths, with: .top)
                isCollapsedProject = !isCollapsedProject
                tableView.endUpdates()
            }
        }
        if section == 1  {
            header.setCollapsed(collapsed: isCollapsedTags)
            
            if isCollapsedTags {
                tableView.beginUpdates()
                let indexPaths = (0 ..< tagViewData.count)
                .map { IndexPath(row: $0, section: 1) }
                print(indexPaths)
                tableView.insertRows(at: indexPaths, with: .top)
                isCollapsedTags = !isCollapsedTags
                tableView.endUpdates()
            }
            else {
                tableView.beginUpdates()
                let indexPaths = (0 ..< tagViewData.count)
                .map { IndexPath(row: $0, section: 1) }
                tableView.deleteRows(at: indexPaths, with: .top)
                isCollapsedTags = !isCollapsedTags
                tableView.endUpdates()
            }
        }
    }
   
    

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
        
        print("Should sort")
        self.sortSections()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .BackgroundColor
        
        // Enable dragging
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true

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
                let backgroundView = UIView()
                if isCollapsedProject == false {
                    backgroundView.backgroundColor = .backgroundColor
                }
                else {
                    backgroundView.backgroundColor = .BackgroundColor
                    headerView.arrowImage.transform = headerView.arrowImage.transform.rotated(by: -.pi/2)
                }
                backgroundView.layer.cornerRadius = 15
                headerView.backgroundView = backgroundView
                
                headerView.view.layer.cornerRadius = 15
                headerView.section = section
                headerView.headerLabel.text = "Projects"
                headerView.image.image = UIImage(named: "ProjectImageLabel")
                headerView.arrowImage.image = UIImage(systemName: "chevron.down.circle")
                headerView.arrowImage.tintColor = .label
                headerView.delegate = self
                return headerView
            }
            if section == 1 {
                let backgroundView = UIView()
                if isCollapsedTags == false {
                    backgroundView.backgroundColor = .backgroundColor
                }
                else{
                    backgroundView.backgroundColor = .BackgroundColor
                    headerView.arrowImage.transform = headerView.arrowImage.transform.rotated(by: -.pi/2)
                }
                backgroundView.layer.cornerRadius = 15
                headerView.backgroundView = backgroundView
                
                headerView.view.layer.cornerRadius = 15
                headerView.section = section
                headerView.headerLabel.text = "Tags"
                headerView.image.image = UIImage(named: "TagImageIcon")
                headerView.arrowImage.image = UIImage(systemName: "chevron.down.circle")
                headerView.arrowImage.tintColor = .label
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
            
            // cell.selectionStyle = .none
            
            // Set selection color & corner radius
            let selectionView = UIView()
            selectionView.backgroundColor = .backgroundColor
            selectionView.layer.cornerRadius = 10
            cell.selectedBackgroundView = selectionView
            
            cell.backgroundColor = .BackgroundColor
            
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
            cell.tagTitle.textColor = .textColor
//            cell.projectLabel.text = tagTitle
//            cell.projectLabel.textColor = UIColor.textColor
            // cell.selectionStyle = .none
            
            // Set selection color & corner radius
            let selectionView = UIView()
            selectionView.backgroundColor = .backgroundColor
            selectionView.layer.cornerRadius = 10
            cell.selectedBackgroundView = selectionView
            
            cell.backgroundColor = .BackgroundColor
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            delegate?.projectSelected(sender: self)
        }
        if indexPath.section == 1 {
            delegate?.tagSelected(sender: self)
        }
    }
    
    // MARK: - Re-/Ordering
    
    func sortSections() {
        if !self.tableViewData.isEmpty {
            self.tableViewData.sort {
                ($0.value(forKey: "sortOrder") as! Int) < ($1.value(forKey: "sortOrder") as! Int)
            }
        }
        if !self.tagViewData.isEmpty {
            self.tagViewData.sort {
                ($0.value(forKey: "sortOrder") as! Int) < ($1.value(forKey: "sortOrder") as! Int)
            }
        }
        self.saveOrder()
    }
    
    func saveOrder() {
        var i = 0
        for project in self.tableViewData {
            project.setValue(i, forKey: "sortOrder")
            i += 1
        }
        
        i = 0
        for tag in self.tagViewData {
            tag.setValue(i, forKey: "sortOrder")
            i += 1
        }
        CoreDataManager.shared.saveContext()
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // Not necessary, but apparently there can be a bug with empty init
        let itemProvider = NSItemProvider(object: "Move" as NSItemProviderWriting)
            
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        if indexPath.section == 0 {
            dragItem.localObject = [0, tableViewData[indexPath.row]]
        }
        else if indexPath.section == 1 {
            dragItem.localObject = [1, tagViewData[indexPath.row]]
        }
        
        return [dragItem]
    }

    func tableView(_ _tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else if session.items.count == 1 {
                // One item, check if the section matches
                if let sourceSection = (session.items[0].localObject as? [Any])?[0] as? Int, let destinationSection = destinationIndexPath?.section {
                    if sourceSection == destinationSection {
                        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
                    }
                }
            }
            return UITableViewDropProposal(operation: .cancel)
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        // Needed for drop delegate, but not called when dragging & dropping in table
        print("perform Drop")
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        switch (sourceIndexPath.section, destinationIndexPath.section) {
        case (0, 0):
            let mover = tableViewData.remove(at: sourceIndexPath.row)
            tableViewData.insert(mover, at: destinationIndexPath.row)
            self.saveOrder()
        case (1, 1):
            let mover = tagViewData.remove(at: sourceIndexPath.row)
            tagViewData.insert(mover, at: destinationIndexPath.row)
            self.saveOrder()
        default:
            break
        }

    }
    
    // MARK: - Context menu

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.section),\(indexPath.row)" as NSString

        if indexPath.section == 0 {
            let project = tableViewData[indexPath.row]
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                
                let alert = UIAlertController(title: "Delete project, and associated tasks?", message: "All tasks belonging to the project will be deleted as well. This action cannot be undone.", preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                    self.tableViewData.remove(at: indexPath.row)
                    CoreDataManager.shared.deleteProject(project)
                    UIView.animate(withDuration: 0.35) {
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    self.delegate?.reloadCollection(sender: self)
                }

                // Add the actions to the alert controller
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)

                // Present the alert controller
                if var rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = rootViewController.presentedViewController {
                        rootViewController = presentedViewController
                    }
                    rootViewController.present(alert, animated: true, completion: nil)
                }
            }
            
            return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil, actionProvider: { _ in
                UIMenu(title: "", identifier: nil, children: [deleteAction])
            })
        }
        
        else {
            let tag = tagViewData[indexPath.row]
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                
                let alert = UIAlertController(title: "Delete tag?", message: "The associated tasks will not be deleted. This action cannot be undone.", preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                    self.tagViewData.remove(at: indexPath.row)
                    CoreDataManager.shared.deleteTag(tag)
                    UIView.animate(withDuration: 0.35) {
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }

                // Add the actions to the alert controller
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)

                // Present the alert controller
                if var rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = rootViewController.presentedViewController {
                        rootViewController = presentedViewController
                    }
                    rootViewController.present(alert, animated: true, completion: nil)
                }
            }
            
            return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil, actionProvider: { _ in
                UIMenu(title: "", identifier: nil, children: [deleteAction])
            })
        }
        




    }


//    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
//        guard
//            let identifier = configuration.identifier as? String
//        else {
//            return nil
//        }
//
//        let array = identifier.components(separatedBy: ",")
//
//        let section = Int(array[0])! as Int
//        let row = Int(array[1])! as Int
//
//        let indexPath = IndexPath(row: row, section: section)
//
//
//        if let cell = tableView.cellForRow(at: indexPath) {
//         // let cellBackground = cell.backgroundView
//         // cell.backgroundColor == UIColor.BackgroundColor
//            return UITargetedPreview(view: cell)
//        }
//        else {
//            return nil
//        }
//    }
}


