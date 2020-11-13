//
//  HabitViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 10/23/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class HabitViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    // Make sure to check numberOfDays with number of Cells per section for DateSelector CollectionView
    func arrayOfDateNumbers() -> NSArray {
            
            let numberOfDays: Int = 14
            let startDate = Date()
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "d"
            let calendar = Calendar.current
            var offset = DateComponents()
            var dates: [Any] = [formatter.string(from: startDate)]
            
            for i in 1..<numberOfDays {
                offset.day = i
                let nextDay: Date? = calendar.date(byAdding: offset, to: startDate)
                let nextDayString = formatter.string(from: nextDay!)
                dates.append(nextDayString)
            }
            return dates as NSArray
        }
    func arrayOfDayOfWeek() -> NSArray {
            
            let numberOfDays: Int = 14
            let startDate = Date()
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "EEE"
            let calendar = Calendar.current
            var offset = DateComponents()
            var dates: [Any] = [formatter.string(from: startDate)]
            
            for i in 1..<numberOfDays {
                offset.day = i
                let nextDay: Date? = calendar.date(byAdding: offset, to: startDate)
                let nextDayString = formatter.string(from: nextDay!)
                dates.append(nextDayString)
            }
            return dates as NSArray
        }
    var dateNumbers:NSArray = []
    var dayOfTheWeek: NSArray = []
    var lastSelectedIndexPath: IndexPath?

    @IBOutlet weak var ProgressBar: PlainCircularProgressBar!

    @IBOutlet weak var DateSelector: UICollectionView!
    @IBOutlet weak var habitTableView: UICollectionView!
    @IBOutlet weak var ProgressLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    var habits = [habit(habitTitle: "Read", habitComplete: false, todoPicture: "Shoes", habitSection: 1, habitTime: nil),habit(habitTitle: "Go for a Walk", habitComplete: false, todoPicture: "Plant", habitSection: 2, habitTime: nil)]
    
    let collectionViewHeaderFooterReuseIdentifier = "HabitTableViewHeaderView"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == habitTableView {
            return 2
        }
        else {
            return 14
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == DateSelector {
            if let cell = collectionView.cellForItem(at: indexPath) as? HabitDateSelectorCell {
//                cell.layer.backgroundColor = UIColor.blue.cgColor
//                cell.Date.textColor = UIColor.white
                cell.isHighlighted = true
            }
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == DateSelector {
            if let cell = collectionView.cellForItem(at: indexPath) as? HabitDateSelectorCell {
//                cell.layer.backgroundColor = UIColor.backgroundColor.cgColor
//                cell.Date.textColor = UIColor.systemGray2
                cell.isHighlighted = false
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == DateSelector {
            return CGSize(width: self.view.frame.width/7, height: 50)
        }
        else{
            return CGSize(width: habitTableView.frame.width - 20, height: 70)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case habitTableView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitTableViewCell" , for: indexPath) as! HabitTableViewCell
            cell.layer.cornerRadius = 20
            cell.layer.backgroundColor = UIColor.backgroundColor.cgColor
            cell.habitTitle.text = habits[indexPath.row].habitTitle
            cell.habitImage.image = UIImage(named: habits[indexPath.row].todoPicture)
            return cell
        case DateSelector:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitDateSelectorCell", for: indexPath) as! HabitDateSelectorCell
            cell.layer.cornerRadius = 15
            
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            let day = dateFormatter.string(from: now)
            if day == dateNumbers[indexPath.row] as? String{
                cell.layer.backgroundColor = UIColor.backgroundColor.cgColor
            }
            else{
                cell.layer.backgroundColor = UIColor.BackgroundColor.cgColor
            }
            cell.Datelabel.text = dateNumbers[indexPath.row] as? String
            cell.Date.text = dayOfTheWeek[indexPath.row] as? String
            cell.Datelabel.textColor = UIColor.white
            return cell
        default:
            return UICollectionViewCell()
        }
//        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitTableViewCell" , for: indexPath) as! HabitTableViewCell
//        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! HabitDateSelectorCell
//        if collectionView == self.habitTableView {
////            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitTableViewCell" , for: indexPath) as! HabitTableViewCell
//            cell1.layer.cornerRadius = 20
//            cell1.layer.backgroundColor = UIColor.backgroundColor.cgColor
//            cell1.habitTitle.text = habits[indexPath.row].habitTitle
//            cell1.habitImage.image = UIImage(named: habits[indexPath.row].todoPicture)
//            return cell1
//        }
//        if collectionView == DateSelector {
//            cell2.layer.cornerRadius = 20
//
//            return cell2
//        }
//
//        return cell1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.habitTableView{
            return 3
        }
        else {
            return 1
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            
        return 10
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == DateSelector {
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return
//    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HabitCollectionViewHeader", for: indexPath) as! HabitCollectionViewHeader
        if collectionView == DateSelector {
            header.frame.size.height = 0.0
            header.frame.size.width = 0.0
            return header
        }
        header.layer.cornerRadius = 15
        header.backgroundColor = .backgroundColor
        header.arrowImage.image = UIImage(systemName: "chevron.down.circle")
        header.arrowImage.tintColor = UIColor.textColor
        header.image.tintColor = UIColor.textColor
        
        if indexPath.section == 0{
            header.headerLabel.text = "Morning"
            header.image.image = UIImage(systemName: "sunrise.fill")
        }
        if indexPath.section == 1{
            header.headerLabel.text = "Evening"
            header.image.image = UIImage(systemName: "sun.max.fill")
        }
        if indexPath.section == 2{
            header.headerLabel.text = "All Day"
            header.image.image = UIImage(systemName: "sunset.fill")
        }
        return header
    }
        
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            if collectionView == habitTableView {
//                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HabitCollectionViewHeader.identifier, for: indexPath) as! HabitCollectionViewHeader
//                header.layer.cornerRadius = 15
//                header.backgroundColor = .backgroundColor
//                header.arrowImage.image = UIImage(systemName: "chevron.down.circle")
//                header.arrowImage.tintColor = UIColor.textColor
//                header.image.tintColor = UIColor.textColor
//
//                if indexPath.section == 0{
//                    header.headerLabel.text = "Morning"
//                    header.image.image = UIImage(systemName: "sunrise.fill")
//                }
//                if indexPath.section == 1{
//                    header.headerLabel.text = "Evening"
//                    header.image.image = UIImage(systemName: "sun.max.fill")
//                }
//                if indexPath.section == 2{
//                    header.headerLabel.text = "All Day"
//                    header.image.image = UIImage(systemName: "sunset.fill")
//                }
//                return header
//            }
//            else {
//
//            }
//        default:
//            preconditionFailure("Invalid supplementary view type for this collection view")
//        }
//    }
//        if collectionView == self.habitTableView {
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HabitCollectionViewHeader.identifier, for: indexPath) as! HabitCollectionViewHeader
//            header.layer.cornerRadius = 15
//            header.backgroundColor = .backgroundColor
//            header.arrowImage.image = UIImage(systemName: "chevron.down.circle")
//            header.arrowImage.tintColor = UIColor.textColor
//            header.image.tintColor = UIColor.textColor
//
//            if indexPath.section == 0{
//                header.headerLabel.text = "Morning"
//                header.image.image = UIImage(systemName: "sunrise.fill")
//            }
//            if indexPath.section == 1{
//                header.headerLabel.text = "Evening"
//                header.image.image = UIImage(systemName: "sun.max.fill")
//            }
//            if indexPath.section == 2{
//                header.headerLabel.text = "All Day"
//                header.image.image = UIImage(systemName: "sunset.fill")
//            }
//
//    //            header.headerLabel.text = "Test"
//    //            header.headerLabel.textColor = UIColor.textColor
//    //        if indexPath.section == 1{
//    //            header.headerLabel.text = "Morning"
//    //        }
//    //        if indexPath.section == 2{
//    //            header.headerLabel.text = "Afternoon"
//    //        }
//    //
//            return header
//        }

//
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == habitTableView {
            return CGSize(width: habitTableView.frame.width, height: 50)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
//MARK: TableView Methods
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        3
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitTableViewCell", for: indexPath) as! HabitTableViewCell
//        cell.habitDescription.text = "Test"
//        cell.habitTitle.text = "Go for walk"
//        cell.backgroundColor = .clear
//        cell.contentView.backgroundColor = .clear
//        return cell
//    }
//
  
//
    @IBAction func ProgressChanged(_ sender: UISlider) {
        let progress = CGFloat(sender.value)
        let progressNumber = NSNumber(value: Float(progress))
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        let progresslabel = numberFormatter.string(from: progressNumber)
        ProgressLabel.text = progresslabel! + " Done"
        ProgressBar.progress = progress
    }
    
    override func viewDidLoad() {
        dateNumbers = arrayOfDateNumbers()
        dayOfTheWeek = arrayOfDayOfWeek()
        DateSelector.allowsMultipleSelection = false
        habitTableView.delegate = self
        habitTableView.dataSource = self
        DateSelector.dataSource = self
        DateSelector.delegate = self
        self.DateSelector.register(UINib(nibName: "HabitDateSelectorCell", bundle: nil), forCellWithReuseIdentifier: "HabitDateSelectorCell")
        self.DateSelector.register(HabitCollectionViewHeader.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HabitCollectionViewHeader.identifier)
        self.habitTableView.register(UINib(nibName: "HabitTableViewCell", bundle: nil), forCellWithReuseIdentifier: "HabitTableViewCell")
        self.habitTableView.register(HabitCollectionViewHeader.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HabitCollectionViewHeader.identifier)
        habitTableView.backgroundColor = .BackgroundColor
        super.viewDidLoad()
   
//        habitTableView.separatorStyle = .none
//        habitTableView.delegate = self
//        habitTableView.dataSource = self
//        habitTableView.backgroundColor = .BackgroundColor
//        super.viewDidLoad()
//        self.habitTableView.register(UINib(nibName: "HabitTableViewCell", bundle: nil), forCellReuseIdentifier: "HabitTableViewCell")
//        self.habitTableView.register(HabitTableViewHeaderView.nib, forHeaderFooterViewReuseIdentifier: HabitTableViewHeaderView.identifiers)
//        ProgressLabel.textColor = UIColor.gray

        // Do any additional setup after loading the view.
    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HabitTableViewHeaderView.identifiers) as? HabitTableViewHeaderView {
//            headerView.contentView.backgroundColor = UIColor.backgroundColor
////            headerView.view.backgroundColor = .BackgroundColor
////            headerView.contentView.backgroundColor = .BackgroundColor
////            headerView.view.backgroundColor = .clear
////            headerView.backgroundView?.backgroundColor = .clear
//            if section == 0 {
//                headerView.headerLabel.text = "Morning"
//                headerView.image.image = UIImage(systemName: "sunrise.fill")
//                headerView.image.tintColor = UIColor.textColor
////                headerView.contentView.backgroundColor = UIColor.BackgroundColor
////                headerView.view.backgroundColor = UIColor.backgroundColor
////                if isCollapsedProject == false {
////                    headerView.view.backgroundColor = UIColor.backgroundColor
////                }
////                else {
////                    headerView.view.backgroundColor = UIColor.BackgroundColor
////                    headerView.arrowImage.transform = headerView.arrowImage.transform.rotated(by: -.pi/2)
////                }
//                headerView.view.layer.cornerRadius = 15
////                headerView.section = section
////                headerView.headerLabel.text = "Projects"
////                headerView.image.image = UIImage(named: "ProjectImageLabel")
//                headerView.arrowImage.image = UIImage(systemName: "chevron.down.circle")
//                headerView.arrowImage.tintColor = .label
////                headerView.delegate = self
//                return headerView
//            }
//            if section == 1 {
//                headerView.headerLabel.text = "Evening"
//                headerView.image.image = UIImage(systemName: "sun.max.fill")
//                headerView.image.tintColor = UIColor.textColor
////                if isCollapsedTags == false {
////                    headerView.view.backgroundColor = UIColor.backgroundColor
////                }
////                else{
////                    headerView.view.backgroundColor = UIColor.BackgroundColor
////                    headerView.arrowImage.transform = headerView.arrowImage.transform.rotated(by: -.pi/2)
////                }
//                headerView.view.layer.cornerRadius = 15
////                headerView.section = section
////                headerView.headerLabel.text = "Tags"
////                headerView.image.image = UIImage(named: "TagImageIcon")
//                headerView.arrowImage.image = UIImage(systemName: "chevron.down.circle")
//                headerView.arrowImage.tintColor = .label
////                headerView.delegate = self
//                return headerView
//            }
//            if section == 2 {
//                headerView.image.image = UIImage(systemName: "sunset.fill")
//                headerView.image.tintColor = UIColor.textColor
//                headerView.headerLabel.text = "All Day"
//                headerView.view.layer.cornerRadius = 15
//                return headerView
//            }
//        }
//        return UIView()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

