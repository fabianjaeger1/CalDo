//
//  HabitViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 10/23/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class HabitViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let collectionViewHeaderFooterReuseIdentifier = "HabitTableViewHeaderView"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitTableViewCell" , for: indexPath) as! HabitTableViewCell
        cell.layer.cornerRadius = 20
        cell.layer.backgroundColor = UIColor.backgroundColor.cgColor
        cell.habitTitle.text = "Test"
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            
        return 10
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            
        return 3
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return
//    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HabitCollectionViewHeader.identifier, for: indexPath) as! HabitCollectionViewHeader
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

//            header.headerLabel.text = "Test"
//            header.headerLabel.textColor = UIColor.textColor
//        if indexPath.section == 1{
//            header.headerLabel.text = "Morning"
//        }
//        if indexPath.section == 2{
//            header.headerLabel.text = "Afternoon"
//        }
//
        return header
    }
//
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: habitTableView.frame.width, height: 50)
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
    @IBOutlet weak var ProgressBar: PlainCircularProgressBar!

    @IBOutlet weak var habitTableView: UICollectionView!
    @IBOutlet weak var ProgressLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
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
        habitTableView.delegate = self
        habitTableView.dataSource = self
        habitTableView.backgroundColor = .BackgroundColor
        super.viewDidLoad()
        self.habitTableView.register(UINib(nibName: "HabitTableViewCell", bundle: nil), forCellWithReuseIdentifier: "HabitTableViewCell")
        self.habitTableView.register(HabitCollectionViewHeader.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HabitCollectionViewHeader.identifier)
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

