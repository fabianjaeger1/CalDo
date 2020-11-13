//
//  DetailViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 9/11/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit


let todoTaskCategories = ["Due", "Project", "Priority", "Tags"]
let todoTaskCategoriesImages = ["clock.fill","folder.fill", "flag.fill"]

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAdaptivePresentationControllerDelegate { 
    
    
    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var todoButton: UIButton!
    @IBOutlet weak var textLine: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var projectColor: UIView!
    
    @IBOutlet weak var todoDate: UILabel!
    
    @IBOutlet weak var priorityButton: UIButton!
    
    var task: TaskEntity!
    var indexPath: IndexPath!
    
    // Spacing between items in collection view
    let spacing: CGFloat = 12

        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        cell.label.text = todoTaskCategories[indexPath.row]
        cell.image.image = UIImage(systemName: todoTaskCategoriesImages[indexPath.row])
        cell.image.tintColor = UIColor.textColor
        cell.backgroundColor = UIColor.clear
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.backgroundColor = .backgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == NSIndexPath(row: 0, section: 0) as IndexPath{
            let vc = ScheduleViewController(nibName: "ScheduleViewController", bundle: nil)
            vc.presentationController?.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath == NSIndexPath(row: 1, section: 0) as IndexPath{
            let vc = ProjectTaskDetailViewController(nibName: "ProjectTaskDetailViewController", bundle: nil)
            vc.presentationController?.delegate = self
            self.present(vc, animated: true, completion: nil)
//            let vc = TodayViewController(nibName: "TaskTableViewController", bundle: nil)
//            vc.presentationController?.delegate = self
//            self.present(vc, animated: true, completion: nil)
        }
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if [0, 1].contains(indexPath.row) {
            let width = (self.view.frame.size.width - 3 * spacing) / 2
            return CGSize(width: width, height: 50)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
       
        collectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        textLine.layer.cornerRadius = 5
        textLine.backgroundColor = .backgroundColor
        
        todoButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        todoTitle.text = task.value(forKey: "title") as? String
        
        let project = task.value(forKey: "project")
        let projectColor = (project as? ProjectEntity)?.value(forKey: "color")
        
        projectTitle.text = (project as? ProjectEntity)?.title ?? "Inbox"
        if projectColor != nil {
             projectTitle.textColor = UIColor(hexString: (projectColor as! String))
        }
       
        let taskHasTime = task.value(forKey: "dateHasTime") as! Bool
        let date = task.value(forKey: "date") as? Date
        let priority = task.value(forKey: "priority") as! Int
        let recurrence = task.value(forKey: "recurrence") as! Bool
        
        todoDate.text = date?.todoString(withTime: taskHasTime) ?? "No Date"
        todoDate.textColor = date?.todoColor(withTime: taskHasTime) ?? .systemGray
        
        var priorityImage: UIImage?
        
        switch priority {
        case 0:
            priorityImage = UIImage(systemName: "flag.fill")!.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        case 1:
            priorityImage = UIImage(systemName: "flag.fill")!.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
        case 2:
            priorityImage = UIImage(systemName: "flag.fill")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        default:
            priorityImage = UIImage(systemName: "flag")!.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        }

        priorityButton.setImage(priorityImage, for: .normal)
        

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
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func completeButtonTapped(sender: UIButton!) {
        
        task.setValue(true, forKey: "completed")
        CoreDataManager.shared.saveContext()
        
        if presentationController is DetailPresentationController {
            (presentationController as!
                DetailPresentationController).detailDelegate?.drawerMovedTo(position: .closed)
            (presentationController as!
                DetailPresentationController).detailDelegate?.completeTaskInDetail(task, indexPath: self.indexPath)
        }
        
        self.dismiss(animated: true)
    }
    

}


