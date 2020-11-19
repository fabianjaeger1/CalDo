//
//  DetailViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 9/11/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit




class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAdaptivePresentationControllerDelegate { 
    
    
    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var todoButton: UIButton!
    @IBOutlet weak var textLine: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // @IBOutlet weak var projectTitle: UILabel!
    // @IBOutlet weak var projectColor: UIView!
    
    @IBOutlet weak var todoDate: UILabel!
    
    @IBOutlet weak var priorityButton: UIButton!
    
    var task: TaskEntity!
    var indexPath: IndexPath!
    
    var projectTitle: String!
    var projectColor: UIColor!
    
    var dateTitle: String!
    var dateTextColor: UIColor!
    
    var collectionTitles: [String]!
    var collectionColors: [UIColor]!
    
    let todoTaskCategories = ["Due", "Project", "Priority", "Tags"]
    let collectionImages = ["clock.fill","folder.fill", "flag.fill", "flag.fill"]
    
    /// Spacing at the margins left and right
    let marginSpacing: CGFloat = 21
    /// Spacing between items in collection view
    let spacing: CGFloat = 12
    
    /// Height of collection view cells
    let cellHeight: CGFloat = 50

        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        
        if [0, 1, 3].contains(indexPath.row) {
            cell.label.text = collectionTitles[indexPath.row]
            cell.image.image = UIImage(systemName: collectionImages[indexPath.row])
            cell.image.tintColor = .textColor
            
            //if indexPath.row == 0 {
            cell.label.textColor = collectionColors[indexPath.row]
        }
        else if indexPath.row == 2 {
            let priority = task.value(forKey: "priority") as! Int
            // let recurrence = task.value(forKey: "recurrence") as! Bool
            
            switch priority {
            case 0:
                cell.image.image = UIImage(systemName: "flag.fill")!.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            case 1:
                cell.image.image = UIImage(systemName: "flag.fill")!.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
            case 2:
                cell.image.image = UIImage(systemName: "flag.fill")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            default:
                cell.image.image = UIImage(systemName: "flag")!.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            }
            
            cell.label.text = nil
            
            cell.labelTrailing.isActive = false
            cell.imageLeading.isActive = false
            cell.imageTrailing.isActive = false
            
            cell.imageWidth.constant = 30
            cell.image.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            cell.image.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            
            cell.widthAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
            
        }

        
        cell.backgroundColor = .clear
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.backgroundColor = .backgroundColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Section:", indexPath.section)
//        print("Row:", indexPath.row)
        if indexPath == NSIndexPath(row: 0, section: 0) as IndexPath {
            let vc = ScheduleViewController(nibName: "ScheduleViewController", bundle: nil)
            vc.presentationController?.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath == NSIndexPath(row: 1, section: 0) as IndexPath {
            let vc = ProjectTaskDetailViewController(nibName: "ProjectTaskDetailViewController", bundle: nil)
            vc.presentationController?.delegate = self
            self.present(vc, animated: true, completion: nil)
//            let vc = TodayViewController(nibName: "TaskTableViewController", bundle: nil)
//            vc.presentationController?.delegate = self
//            self.present(vc, animated: true, completion: nil)
        }
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if [0, 1].contains(indexPath.row) {
//            let width = (self.view.frame.size.width - 2 * marginSpacing - spacing) / 2
//            return CGSize(width: width, height: cellHeight)
//        }
//        else {
//            return CGSize(width: 0, height: 0)
//        }
//    }
    
    func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
    }

    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let widthDimension = NSCollectionLayoutDimension.estimated(49)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            // item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(20), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))
            // item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: self.spacing, bottom: 0, trailing: self.spacing)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.cellHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: self.marginSpacing, bottom: 0, trailing: self.marginSpacing)
            group.interItemSpacing = .fixed(self.spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = self.spacing
            
            return section
        }
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
//        layout.sectionInset = UIEdgeInsets(top: 0, left: marginSpacing, bottom: 0, right: marginSpacing)
//        layout.minimumLineSpacing = spacing
//        layout.minimumInteritemSpacing = spacing
        
        // let layout = collectionView.collectionViewLayout as! UICollectionViewCompositionalLayout
        
        configureCollectionView()
       
        collectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        textLine.layer.cornerRadius = 5
        textLine.backgroundColor = .backgroundColor
        
        todoButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        todoTitle.text = task.value(forKey: "title") as? String
        
        
        
        let priority = task.value(forKey: "priority") as! Int
        let recurrence = task.value(forKey: "recurrence") as! Bool
        
        switch recurrence {
        case true:
            switch priority {
            case 0:
                todoButton.setImage(UIImage(named: "Recurring"), for: .normal)
            case 1:
                todoButton.setImage(UIImage(named: "Recurring Normal"), for: .normal)
            case 2:
                todoButton.setImage(UIImage(named: "Recurring High" ), for: .normal)
            default:
                todoButton.setImage(UIImage(named: "Recurring" ), for: .normal)
            }
        default:
            switch priority {
            case 0:
                todoButton.setImage(UIImage(named: "TodoButton"), for: .normal)
            case 1:
                todoButton.setImage(UIImage(named: "Todo Medium Priority"), for: .normal)
            case 2:
                todoButton.setImage(UIImage(named: "Todo High Priority"), for: .normal)
            default:
                todoButton.setImage(UIImage(named: "TodoButton"), for: .normal)
            }
        }
        
        self.view.backgroundColor = .BackgroundColor
        
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, task: TaskEntity, indexPath: IndexPath) {
        self.task = task
        self.indexPath = indexPath
        
        let project = task.value(forKey: "project")
        let projectColorString = (project as? ProjectEntity)?.value(forKey: "color")
         
        projectTitle = (project as? ProjectEntity)?.title ?? "Inbox"

        if projectColorString != nil {
            projectColor = UIColor(hexString: (projectColorString as! String))
        }
        else {
            projectColor = .textColor
        }

        let taskHasTime = task.value(forKey: "dateHasTime") as! Bool
        let date = task.value(forKey: "date") as? Date

        dateTitle = date?.todoString(withTime: taskHasTime) ?? "No Date"
        dateTextColor = date?.todoColor(withTime: taskHasTime) ?? .systemGray

        collectionTitles = [dateTitle, projectTitle, "Test1", "Test2"]
        collectionColors = [dateTextColor, projectColor, .textColor, .textColor]
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func completeButtonTapped(sender: UIButton!) {
        
        // CoreDataManager.shared.completeTask(task)
        
        if presentationController is DetailPresentationController {
            (presentationController as!
                DetailPresentationController).detailDelegate?.drawerMovedTo(position: .closed)
            (presentationController as!
                DetailPresentationController).detailDelegate?.completeTaskInDetail(task, indexPath: self.indexPath)
        }
        
        self.dismiss(animated: true)
    }
    

}


