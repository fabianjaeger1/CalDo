//
//  ScheduleViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 10/11/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = presentingViewController.view.bounds
        let size = CGSize(width: 370, height: 670)
        let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
        return CGRect(origin: origin, size: size)
    }
    
    private lazy var dismissView: UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
//        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        view.isUserInteractionEnabled = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PresentationController.touchCallback(_:)))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        presentedView?.autoresizingMask = [
            .flexibleTopMargin,
            .flexibleBottomMargin,
            .flexibleLeftMargin,
            .flexibleRightMargin
        ]
        presentedView?.layer.cornerRadius = 20
        presentedView?.layer.backgroundColor = UIColor.BackgroundColor.cgColor
        presentedView?.translatesAutoresizingMaskIntoConstraints = true
    }
    
//    let dimmingView: UIView = {
//        let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//        dimmingView.translatesAutoresizingMaskIntoConstraints = false
//        return dimmingView
//    }()

    override func presentationTransitionWillBegin() {
        // Possibly implement BlurView?
//        let dismissView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//        dismissView.frame = self.containerView!.bounds
//        let dismissView = UIView(frame: self.containerView!.bounds)
//        dismissView.backgroundColor = UIColor.clear
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PresentationController.touchCallback(_:)))
//        dismissView.addGestureRecognizer(tapGesture)
        containerView?.addSubview(self.dismissView)
        
        self.dismissView.alpha = 0
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.dismissView.alpha = 1
//            self.dismissView.backgroundColor = .backgroundColor
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    @objc func touchCallback(_ sender: UITapGestureRecognizer? = nil) {
         
        let vcb = presentedViewController as! ScheduleViewController
        
        vcb.dismiss(animated: true, completion: nil)
      }
    

    override func dismissalTransitionWillBegin() {
//        super.dismissalTransitionWillBegin()
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.dismissView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.dismissView.removeFromSuperview()
        })
    }
}

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    var task: TaskEntity!
//    var indexPath: IndexPath!
//
//    var dateTitle: String!
//
//    
//    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, task: TaskEntity, indexPath: IndexPath) {
//        self.task = task
//        self.indexPath = indexPath
//        
//        let taskHasTime = task.value(forKey: "dateHasTime") as! Bool
//        let date = task.value(forKey: "date") as? Date
//
//        dateTitle = date?.todoString(withTime: taskHasTime) ?? "No Date"
//
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titleString = ["Time", "Repeat", "Reminder"]
        let imageString = ["When_Todo", "Repeat_Todo","Reminder_Todo"]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        
        cell.selectionStyle = .none
        cell.tableViewTitle.text = titleString[indexPath.row]
        cell.tableViewDetailLabel.text = ""
        cell.tableViewTitle.textColor = .textColor
        cell.backgroundColor = .BackgroundColor
        
        cell.tableViewImage.image = UIImage(named: imageString[indexPath.row])!.withTintColor(UIColor.textColor)
        // for SF Symbols
//        let pointSize:CGFloat = 26.0
//        let configuration = UIImage.SymbolConfiguration(pointSize: pointSize)
//        cell.tableViewImage.image = UIImage(named: imageString[indexPath.row])!.withTintColor(.label, renderingMode: .alwaysOriginal).withConfiguration(configuration)

        
        return cell
    }

    let redColor = UIColor(hexString: "E02020")
    let blueColor = UIColor(hexString: "0091FF")
    
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var tomorrowButton: UIButton!
    @IBOutlet weak var nextWeekButton: UIButton!
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private var customTransitioningDelegate = TransitioningDelegate()

    override func viewDidLoad() {
        
        // Register all of your cells
        self.tableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleTableViewCell")
        
        self.tableView.backgroundColor = .BackgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        SaveButton.backgroundColor = UIColor(named: "BlueDateSelectorColor")
        clearButton.backgroundColor = .red
        SaveButton.layer.cornerRadius = 12
        clearButton.layer.cornerRadius = 12
        
        
        let pointSize:CGFloat = 26.0
        
        let pointSizeConfiguration = UIImage.SymbolConfiguration(pointSize: pointSize)
        
        let todayColor = UIColor(hexFromString: "F7B500")
        let tomorrowColor = UIColor(hexFromString: "FA6400")
        let nextWeekColor = UIColor(hexFromString: "32C5FF")
        
        let todayImage = UIImage(systemName: "sun.min.fill",withConfiguration: pointSizeConfiguration)?.withTintColor(todayColor, renderingMode: .alwaysOriginal)
        let tomorrowImage = UIImage(systemName: "sunrise.fill", withConfiguration: pointSizeConfiguration)?.withTintColor(tomorrowColor, renderingMode: .alwaysOriginal)
        let nextWeekImage = UIImage(systemName: "calendar",withConfiguration: pointSizeConfiguration)?.withTintColor(nextWeekColor, renderingMode: .alwaysOriginal)
        
        todayButton.setImage(todayImage, for: .normal)
        tomorrowButton.setImage(tomorrowImage, for: .normal)
        nextWeekButton.setImage(nextWeekImage, for: .normal)
        todayButton.centerVertically()
        tomorrowButton.centerVertically()
        nextWeekButton.centerVertically()

        

//        tomorrowButton.centerVertically()
//        todayButton.centerVertically()
//        nextWeekButton.centerVertically()
        
//        todayButton.imageView?.tintColor = UIColor.red
//        todayButton.tintColor = UIColor.red
//        todayButton.tintColor = UIColor(named: "#F7B500")
//        tomorrowButton.tintColor = UIColor(named: "#FA6400")
//        nextWeekButton.tintColor = UIColor(named: "#32C5FF")
        super.viewDidLoad()
        self.view.backgroundColor = .BackgroundColor
        // Do any additional setup after loading the view.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
           super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
           configure()
       }

       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           configure()
       }

}

private extension ScheduleViewController {
    func configure() {
         modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve // use whatever transition you want
         transitioningDelegate = customTransitioningDelegate
    }
}

