//
//  NewTaskViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 27.07.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit
import TagListView

//extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return "String".size(withAttributes: [
//            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)
//            ])
//    }
//}

class NewTaskViewController: UIViewController, ChooseProjectsViewControllerDelegate, SendDateAndTimeback, UICollectionViewDelegate, UICollectionViewDataSource, ChooseTagsViewControllerDelegate, UICollectionViewDelegateFlowLayout{
    
    let impact = UIImpactFeedbackGenerator() 
    
    let buttonBar = UIView()
    let segmentedControl = UISegmentedControl()
    let shapeLayer = CAShapeLayer()
    
    
// ==================== DELEGATE VARIABLES ==============================
    
    var ProjectSelectedIndex: IndexPath?
    var RepeatSelectedIndex: IndexPath?
    
    //Storing the index paths for the table Views in the Task creation

    
    var ProjectSelected: Project?
    var TimeAndDateSelected: DateAndTime?
    var TagsSelected: [tag]?
    
    var SelectedDate: String?
    var SelectedTime: String?

// ================ DELEGATE FUNCTIONS ========================
    
    func DateAndTimeReceived(data: DateAndTime) {
            self.TimeAndDateSelected = data
            if TimeAndDateSelected!.time == "Add Time"
            {
            SelectedDate = TimeAndDateSelected!.date!
            }
            else if TimeAndDateSelected!.time != nil{
                SelectedDate = TimeAndDateSelected!.date!
                SelectedTime = TimeAndDateSelected!.time!
        }
            updateWhen()
    }

    
    func didSelect(ProjectSelected: Project) {
        self.ProjectSelected = ProjectSelected
        updateProject()
    }

    
    func TagDataReceived(tagsSelected: [tag]) {
        self.TagsSelected = tagsSelected
        updateTag()
    }
    

// ==================== DELEGATE INFORMATION HANDLING ============================
    
    func updateTag(){
        TagCollectionView.reloadData()
        
        // All the loading of the Data happens inside the Collection View Functions
    }
    
    func updateWhen(){
        if TimeAndDateSelected != nil{
            if TimeAndDateSelected!.time == "Add Time"{
                WhenLabel.text! = "\(TimeAndDateSelected!.date!)"
            }
            else if TimeAndDateSelected!.time != nil{
                WhenLabel.text! = "\(TimeAndDateSelected!.date!) at \(TimeAndDateSelected!.time!)"
            }
        } else {
            WhenLabel.text = "Not Set"
        }
    }
    
    
    func  updateProject(){
        if ProjectSelected != nil {
            ProjectLabel.text = ProjectSelected?.ProjectTitle
            ProjectLabel.sizeToFit()
        } else {
            ProjectLabel.text = ""
        }
        if ProjectSelected != nil{
            if ProjectSelected?.ProjectColor != nil{
                shapeLayer.fillColor = UIColor().HexToColor(hexString: (ProjectSelected?.ProjectColor!)!, alpha: 1).cgColor
            }
            else{
                shapeLayer.fillColor = UIColor.clear.cgColor
            }
        } else {
            ProjectColor.backgroundColor = UIColor.clear
        }
    }
    
    func updateDateView(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        //dateFormatter.timeStyle = .short
        
        
        // TRY TO CREATE RELATIVE DATES FOR WHEN
    }

// ========================= IBOUTLETS ========================
    
    
    @IBOutlet weak var BackgroundView1: UIView!
    @IBOutlet weak var BackgroundView2: UIView!
    @IBOutlet weak var BackgroundView3: UIView!
    @IBOutlet weak var BackgroundView4: UIView!
    @IBOutlet weak var BackgroundView5: UIView!
    @IBOutlet weak var BackgroundView6: UIView!

    @IBOutlet weak var TagCollectionView: UICollectionView!
    
    @IBOutlet weak var PriorityView: UIView!
    @IBOutlet weak var BackgroundView: UIView!
    @IBOutlet weak var WhenLabel: UILabel!
    @IBOutlet weak var ProjectLabel: UILabel!
    @IBOutlet weak var ProjectColor: UIView!
    
    @IBOutlet weak var TaskInput: UITextField!
    

    func layoutSubview() {
//        ProjectColor.layer.cornerRadius = 20
//        ProjectColor.layer.masksToBounds = true
//        ProjectColor.round()
    }
    
//===================== IBACTIONS =====================
    
    
    @IBAction func Done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func TagButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "SelectTags", sender: self)
        impact.impactOccurred()
    }
    

    @IBAction func WhenButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "DatePopUp", sender: self)
        impact.impactOccurred()
    }
    
    @IBAction func ProjectButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "SelectProjectType", sender: self)
        impact.impactOccurred()
    }
    
    @IBAction func RepeatButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showRepeat", sender: self)
        impact.impactOccurred()
    }
    @IBAction func AddButtonPressed(_ sender: Any) {
        
//       let TaskName = TaskInput.text ?? ""
//        let TaskPriority = segmentedControl.selectedSegmentIndex
//        let Projectlabel = ProjectLabel.text!
//        let ProjectColor = shapeLayer.fillColor!
//        let Date = TimeAndDateSelected?.date
//        let Time = TimeAndDateSelected?.time
//
//
    
//       ===== CHECK VALUES INPUTED =======
        
//        print("TaskName: \(TaskName)")
//        print("Task Priority: \(TaskPriority)")
//        print("Project Label: \(Projectlabel)")
//        print("Project Color: \(ProjectColor)")
//        print("Date: \(Date!)")
//        print("Time: \(Time!)")
        
        
    }
    
    
    @IBAction func RemoveButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.2) {
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
                self.impact.impactOccurred()
        }
    }
    
    
    
    @objc func swipeDown(sender: UIGestureRecognizer){
        dismiss(animated: true, completion: {()->Void in
            print("done");
        });
    }
    
    
    
// ================== TAG COLLECTION VIEW =========================
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if TagsSelected == nil {
            return 0
        }
        else {
            return TagsSelected!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        if TagsSelected != nil{
        let tag = TagsSelected![indexPath.row]
        cell.TagLabel!.text = tag.tagLabel
        cell.TagLabel!.textColor = tag.tagColor
        }
        else {
            cell.TagLabel!.text = ""
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let tag = TagsSelected![indexPath.row].tagLabel!
//        let attributedtag = NSAttributedString(string: tag)
//  //      return attributedtag.size()
//
//    }
    
    
    
  

//*************************************************************************************
    
override func viewDidLoad() {

    
    self.navigationController?.viewControllers.remove(at: 0)
    
    // tells the VC that the Task input textfield should be opended when VC is loaded
//    TaskInput.becomeFirstResponder()
        
    updateProject()
    updateWhen()
    updateTag()
        
    layoutSubview()
    
    
    if #available(iOS 13.0, *) {
        self.BackgroundView.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        } // Change Color of Background based on system preference
        

// ================== TAG COLLECTION DATASOURCE AND DELEGATE ==========================
        
        TagCollectionView.delegate = self
        TagCollectionView.dataSource = self
    

        
// ==================== PROJECT VIEW ====================
        
        
        let center = CGPoint(x: ProjectColor.frame.height/2, y: ProjectColor.frame.width/2)
        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(5), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
    
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3.0
        
        ProjectColor.layer.addSublayer(shapeLayer)
    
        
// ================== CREATING THE PRIORITY SEGMENTED CONTROL ============================
        segmentedControl.insertSegment(with: UIImage(named: "Priority_Filled"), at: 0, animated: true)
        segmentedControl.insertSegment(with: UIImage(named: "Priority_Filled"), at: 1, animated: true)
        segmentedControl.insertSegment(with: UIImage(named: "Priority_Filled"), at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        BackgroundView.addSubview(segmentedControl)
        segmentedControl.leftAnchor.constraint(equalTo: PriorityView.leftAnchor).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: PriorityView.rightAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: PriorityView.topAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: PriorityView.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        (segmentedControl.subviews[2] as UIView).tintColor = UIColor(hexString: "E1E4E7")
        (segmentedControl.subviews[1] as UIView).tintColor = UIColor(hexString: "F5A623")
        (segmentedControl.subviews[0] as UIView).tintColor = UIColor(hexString: "D8434D")
    
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
    
        segmentedControl.removeBorders()
        
// ---------------- BUTTON BAR (BAR BELOW THE PIORTITY LABELS) -----------------
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor(hexString: "4FC2E8")
        
        PriorityView.addSubview(buttonBar)
        
        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        buttonBar.layer.cornerRadius = 2
        buttonBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        buttonBar.leftAnchor.constraint(equalTo: PriorityView.leftAnchor).isActive = true
        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
        
        PriorityView.layer.backgroundColor = UIColor.clear.cgColor
        
// ============== Background View Formatting ==========================

//        BackgroundView.layer.shadowColor = UIColor.darkGray.cgColor
//        BackgroundView.layer.shadowRadius = 50
//        BackgroundView.layer.shadowOpacity = 0.20
        BackgroundView.layer.cornerRadius = 20
    
        BackgroundView1.layer.cornerRadius = 20
        BackgroundView1.layer.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor
        
        BackgroundView2.layer.cornerRadius = 20
        BackgroundView2.layer.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor
        
        BackgroundView3.layer.cornerRadius = 20
        BackgroundView3.layer.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor
        
        BackgroundView4.layer.cornerRadius = 20
        BackgroundView4.layer.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor
        
        BackgroundView5.layer.cornerRadius = 20
        BackgroundView5.layer.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor
        
        BackgroundView6.layer.cornerRadius = 20
        BackgroundView6.layer.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor
    
        
        super.viewDidLoad()
        
//        self.modalPresentationStyle = UIModalPresentationStyle.currentContext
//        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
    
        
//        let swipeRecognizer : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(NewTaskViewController.swipeDown(sender:)))
//        swipeRecognizer.direction = UISwipeGestureRecognizer.Direction.down;
//        view.addGestureRecognizer(swipeRecognizer)
    }
    
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SelectProjectType": do {
                let destinationViewController = segue.destination as?
                ChooseProjectsViewController
                destinationViewController?.delegate = self
                destinationViewController?.SelectedProject = ProjectSelected
            }
        case "DatePopUp": do {
            let secondVC = segue.destination as? DatePopUpViewController
            secondVC?.delegate = self
            if WhenLabel.text != "Not Set" {
                if SelectedTime == nil {
                }
                else {
                    secondVC!.timePreviouslySelected = SelectedTime
                    secondVC!.datePreviouslySelected = SelectedDate
                    SelectedTime = nil
                }
            }

        }
        case "SelectTags": do{
            let seconcVC = segue.destination as! TagListViewController
            seconcVC.delegate = self
            }
            
        default: break
    }
}
 
}
