//
//  UpcomingTaskTableView.swift
//  CalDo
//
//  Created by Nathan Baudis  on 12/17/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class UpcomingTaskTableView: TaskTableView, UITableViewDropDelegate {
    
    var hierarchicalData = [[TaskEntity]]()
    var sectionTitles = [String]()
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hierarchicalData[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return hierarchicalData.count
    }
    
    override func taskAtIndexPath(_ indexPath: IndexPath) -> TaskEntity {
        return hierarchicalData[indexPath.section][indexPath.row]
    }
    
    override init?(_ tv: UITableView, _ predicate: NSPredicate, _ sortVariable: String) {
        super.init(tv, predicate, sortVariable)
        tableView.register(UpcomingHeaderView.nib, forHeaderFooterViewReuseIdentifier: UpcomingHeaderView.identifier)
        tableView.dropDelegate = self
    }
    
    override func completeTask(indexPath: IndexPath, withSections: Bool = true) -> TaskEntity {
        var task = taskAtIndexPath(indexPath)
        let recurrence = task.value(forKey: "recurrence") as! Bool
        
        let oldSection = hierarchicalData.firstIndex(where: {$0.contains(task)})!
        let oldSectionSize = hierarchicalData[oldSection].count
        let oldNumberOfSections = hierarchicalData.count
        let oldSectionTitle = sectionTitles[oldSection]
        
        // New index path in case the row needs to be reloaded
        var newIndexPath = IndexPath()
        
        self.tableView.performBatchUpdates({
            task = super.completeTask(indexPath: indexPath, withSections: true)
            refreshSections()
            let newNumberOfSections = hierarchicalData.count
            
            // Recurring task, i.e. it can move to another section
            if recurrence {
                let newSection = hierarchicalData.firstIndex(where: {$0.contains(task)})!// ?? oldSection
                print("New Section: ", newSection)
                let newSectionSize = hierarchicalData[newSection].count
                
                // Task moves to another section
                if newSection != oldSection {
                    
                    // Was only task in old section, needs to be deleted
                    if oldSectionSize == 1 {
                        
                        // New section is created
                        if oldNumberOfSections == newNumberOfSections {
                            print("New section 1")
                            tableView.insertSections([newSection], with: .fade)
                            
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            newIndexPath = IndexPath(row: 0, section: newSection)
                            tableView.insertRows(at: [newIndexPath], with: .top)
                        }
                        // Task moves to existing section
                        else {
                            let newRow = hierarchicalData[newSection].firstIndex(of: task)! // ?? 0
                            
                            newIndexPath = IndexPath(row: newRow, section: newSection)
                            tableView.moveRow(at: indexPath, to: newIndexPath)
                        }
                        tableView.deleteSections([oldSection], with: .fade)
                    }
                    // Old section remains
                    else {
                        // Task moves to existing section
                        if oldNumberOfSections == newNumberOfSections {
                            let newRow = hierarchicalData[newSection].firstIndex(of: task)! // ?? 0
                            newIndexPath = IndexPath(row: newRow, section: newSection)
                            tableView.moveRow(at: indexPath, to: newIndexPath)
                        }
                        // New section is created
                        else {
                            tableView.insertSections([newSection], with: .fade)
                            
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            newIndexPath = IndexPath(row: 0, section: newSection)
                            tableView.insertRows(at: [newIndexPath], with: .top)
                        }
                    }
                    
                }
                
                // Section number stays the same, but section itself can still change
                else {
                    // Task moves into next section and old section gets deleted (-> stays same section number)
                    if newSectionSize != oldSectionSize {
                        let newRow = hierarchicalData[newSection].firstIndex(of: task)!

                        tableView.deleteSections([oldSection], with: .fade)
                        newIndexPath = IndexPath(row: newRow, section: newSection)
                        tableView.insertRows(at: [newIndexPath], with: .top)
                    }
                    // Section title can still change, reload section if title changes to refresh header
                    else {
                        let newSectionTitle = sectionTitles[newSection]
                        if newSectionTitle != oldSectionTitle {
                            tableView.reloadSections([indexPath.section], with: .fade)
                        }
                        else {
                            newIndexPath = indexPath
                        }
                    }
                }
            }
            // Task isn't recurring, i.e. it can only be the last one in its section
            else {
                if oldNumberOfSections != newNumberOfSections {
                    tableView.deleteSections([indexPath.section], with: .fade)
                }
            }
        })
        
        if !newIndexPath.isEmpty {
            tableView.reloadRows(at: [newIndexPath], with: .fade)
        }
        return task
    }
    
    // MARK: - Generate Sections
    
    // Generate sections and titles, called after refreshing table view data
    func refreshSections() {
        hierarchicalData = [[TaskEntity]]()
        sectionTitles = [String]()
        
        let tasks = isFiltering ? filteredTableViewData : tableViewData

        let cal = Calendar.current
        let currentDate = cal.startOfDay(for: Date())
  
        // Group into dictionary by time difference to current time
        let minuteDifferenceDictionary = Dictionary(grouping: tasks, by: {(task: TaskEntity) -> Int in
            let date = task.value(forKey: "date") as! Date
            return (cal.dateComponents([.minute], from: currentDate, to: date).minute ?? 0)
        })
        
        // Split tasks into overdue and non-overdue
        var overdueTasks = [TaskEntity]()
        var notOverdueTasks = [TaskEntity]()
        for key in minuteDifferenceDictionary.keys {
            if key < 0 {
                overdueTasks += minuteDifferenceDictionary[key]!
            }
            else {
                notOverdueTasks += minuteDifferenceDictionary[key]!
            }
        }
        if !overdueTasks.isEmpty {
            hierarchicalData.append(overdueTasks)
            sectionTitles.append("Overdue")
        }
        
        // Group into dictionary by day differences
        let dayDifferenceDictionary = Dictionary(grouping: notOverdueTasks, by: {(task: TaskEntity) -> Int in
            let date = task.value(forKey: "date") as! Date
            return (cal.dateComponents([.day], from: currentDate, to: date).day ?? 0)
        })
        
        // Tasks further away than a week
        var monthTasks = [TaskEntity]()
        
        for key in dayDifferenceDictionary.keys.sorted() {
            // Get tasks from the next week into own sections
            if key >= 0 && key < 7 {
                hierarchicalData.append(dayDifferenceDictionary[key]!)
                // Take first task to get section title
                let sampleTask = dayDifferenceDictionary[key]![0]
                let sampleDate = sampleTask.value(forKey: "date") as! Date
                sectionTitles.append(sampleDate.upcomingSectionTitle())
            }
            if key >= 7 {
                monthTasks += dayDifferenceDictionary[key]!
            }
        }
        
        // Group remaining tasks into dictionary by month
        let monthDictionary = Dictionary(grouping: monthTasks, by: {(task: TaskEntity) -> Int in
            let date = task.value(forKey: "date") as! Date
            return (cal.dateComponents([.month], from: date).month!)
        })
        
        // Make month sections
        for key in monthDictionary.keys.sorted() {
            hierarchicalData.append(monthDictionary[key]!)
            // Take first task to get section title
            let sampleTask = monthDictionary[key]![0]
            let sampleDate = sampleTask.value(forKey: "date") as! Date
            sectionTitles.append(sampleDate.upcomingSectionTitle())
        }
        
        sortTasks()
    }
    
    override func refreshTableView() {
        super.refreshTableViewData()
        self.refreshSections()
        self.sortTasks()
    }

    
    
    // MARK: - Section Headers
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: UpcomingHeaderView.identifier) as? UpcomingHeaderView {
            
            let text = sectionTitles[section]
            let attributedText = NSMutableAttributedString(string: text)
            // If title has a date (after ·), split to change font color and weight
            let subStrings = text.components(separatedBy: "·")
            
            func getRangeOfSubString(subString: String, fromString: String) -> NSRange {
                let sampleLinkRange = fromString.range(of: subString)!
                let startPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.lowerBound)
                let endPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.upperBound)
                let linkRange = NSMakeRange(startPos, endPos - startPos)
                return linkRange
            }
            
            attributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.label], range: getRangeOfSubString(subString: subStrings[0], fromString: text))
            if subStrings.count > 1 {
                attributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel], range: getRangeOfSubString(subString: "·" + subStrings[1], fromString: text))
                attributedText.addAttributes([NSAttributedString.Key.font: UIFont(name: "SFProRounded-SemiBold", size: 20)!], range: getRangeOfSubString(subString: subStrings[1], fromString: text))
            }
            
            headerView.sectionTitle.attributedText = attributedText
            
            if sectionTitles[section] == "Overdue" {
                headerView.sectionTitle.textColor = .systemRed
            }
            
            return headerView
    }
    return UIView()
    }
    
    // MARK: - Search Bar
    override func filterTasksForSearchText(_ searchText: String) {
        filteredTableViewData = tableViewData.filter { (task: TaskEntity) -> Bool in
            return task.title!.lowercased().contains(searchText.lowercased())
        }
        refreshSections()
        tableView.reloadData()
    }
    
    
    
    // MARK: - Sorting/Ordering
    
    override func sortTasks() {
        if !self.hierarchicalData.isEmpty {
            print(self.sortVariable)
            hierarchicalData = hierarchicalData.map({
                var section = $0
                section.sort {
                    ($0.value(forKey: self.sortVariable) as! Int) < ($1.value(forKey: self.sortVariable) as! Int)
                }
                return section
            })
            self.saveTaskOrder()
        }
    }
    
    override func saveTaskOrder() {
        var i = 0
        for section in hierarchicalData {
            for task in section {
                task.setValue(i, forKey: self.sortVariable)
                i += 1
            }
        }
        CoreDataManager.shared.saveContext()
    }

    
    // MARK: - Reordering
    
    override func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // Not necessary, but apparently there can be a bug with empty init
        let itemProvider = NSItemProvider(object: "Move" as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        dragItem.localObject = [indexPath.section, hierarchicalData[indexPath.section][indexPath.row]]
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
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {
            let mover = hierarchicalData[sourceIndexPath.section].remove(at: sourceIndexPath.row)
            hierarchicalData[destinationIndexPath.section].insert(mover, at: destinationIndexPath.row)
            self.saveTaskOrder()
        }

    }

}



