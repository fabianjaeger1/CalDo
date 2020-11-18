//
//  SmallTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 06.08.20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

@objc protocol SmallTaskTableViewCellDelegate: class {
    func checkmarkTapped(sender: SmallTaskTableViewCell)
    func finishEditing(sender: SmallTaskTableViewCell)
    func hasPerformedSwipe(passedInfo: String)
}


class SmallTaskTableViewCell: UITableViewCell {
    
    weak var delegate: SmallTaskTableViewCellDelegate?
    var originalCenter = CGPoint()
    var isSwipeSuccesful = false
    var myViewController: TaskTableViewController?


    @IBOutlet weak var TodoStatus: UIButton!
    @IBOutlet weak var taskTitle: TaskTitleTextField!
    @IBOutlet weak var TodoDate: UILabel!
    @IBOutlet weak var TodoNotesIcon: UIImageView!
    @IBOutlet weak var TodoLocationIcon: UIImageView!
    
    @IBOutlet weak var todoStatusWidth: NSLayoutConstraint!
    @IBOutlet weak var todoStatusLeading: NSLayoutConstraint!
    
    var isInEditingMode: Bool = false
    var titleIsInEditingMode: Bool = false
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        delegate?.checkmarkTapped(sender: self)
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        

        initialize()
        // Initialization code
        taskTitle.returnKeyType = .done
        taskTitle.clearButtonMode = .whileEditing
        taskTitle.borderStyle = .none
        taskTitle.keyboardType = .alphabet
        taskTitle.autocapitalizationType = .sentences
    }
    
    let kLabelLeftMargin: CGFloat = 15.0
    let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 50.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    func initialize() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        recognizer.delegate = self
        let scheduleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let selectLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        scheduleLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0,
                                     width: kUICuesWidth, height: bounds.size.height)
        selectLabel.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: 0,
                                   width: kUICuesWidth, height: bounds.size.height)
        self.addSubview(scheduleLabel)
        self.addSubview(selectLabel)
        addGestureRecognizer(recognizer)
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
        originalCenter = center
    }
        if recognizer.state == .changed {
            checkIfSwiped(recognizer: recognizer)
        }
        if recognizer.state == .ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            if isSwipeSuccesful, let delegate = self.delegate {
                delegate.hasPerformedSwipe(passedInfo: "I performed a swipe")
                } else {
                moveViewBackIntoPlace(originalFrame: originalFrame)
            }
        }
        
    }
    
    
    func checkIfSwiped(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
        isSwipeSuccesful = frame.origin.x > frame.size.width/2.0
    }
    
    func moveViewBackIntoPlace(originalFrame: CGRect) {
        UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if abs(translation.x) > abs(translation.y){
                return true
            }
        }
        return false
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
        override func setEditing(_ editing: Bool, animated: Bool) {
            
            var realEditing: Bool
            if let vc = myViewController {
                realEditing = vc.realIsEditing
            }
            else {
                realEditing = false
            }

            if (editing && realEditing) {
                showsReorderControl = false
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        // self.TodoStatus.setImage(nil, for: .normal)
                }, completion: { _ in
                    self.todoStatusWidth.constant = 0
                    self.todoStatusLeading.constant = 13
                    // self.TodoStatus.isEnabled = false
                    super.setEditing(editing, animated: animated)
                    self.isInEditingMode = true
                })
            }
            else {
    //            UIView.animate(
    //                withDuration: 0.3,
    //                animations: {
    //                    // self = TaskTableView.tableView(self)
    //            }, completion: { _ in
    //                self.todoStatusWidth.constant = 42
    //                self.todoStatusLeading.constant = 10
    //                self.stackLeading.constant = 52
    //                self.TodoStatus.isEnabled = true
    //                super.setEditing(editing, animated: animated)
    //            })
                if (self.isInEditingMode) {
                    self.todoStatusWidth.constant = 42
                    self.todoStatusLeading.constant = 10
                    
                    delegate?.finishEditing(sender: self)
                    //self.isInEditingMode = false
                    //self.TodoStatus.isEnabled = true
                }
                super.setEditing(editing, animated: animated)
            }
            
        }

    
    
}
