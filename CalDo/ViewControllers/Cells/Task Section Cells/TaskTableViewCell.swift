//
//  TaskTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 06.08.20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

@objc protocol TaskTableViewCellDelegate: class {
    func checkmarkTapped1(sender: TaskTableViewCell)
    func finishEditing1(sender: TaskTableViewCell)
}

//protocol TaskCellDelegate: class{
//    func checkmarkTapped(sender: )
//}

class TaskTableViewCell: UITableViewCell {
    
    weak var delegate: TaskTableViewCellDelegate?
    var myViewController: TaskTableViewController?
    
    @IBOutlet weak var Tag1: UILabel!
    @IBOutlet weak var Tag2: UILabel!
    @IBOutlet weak var Tag3: UILabel!
    @IBOutlet weak var Tag4: UILabel!
    @IBOutlet weak var Tag5: UILabel!
     
    @IBOutlet weak var ProjectLabel: UILabel!
    @IBOutlet weak var ProjectColor: UIView!
    @IBOutlet weak var TodoStatus: UIButton!
    @IBOutlet weak var TodoTitle: UILabel!
    @IBOutlet weak var TodoDate: UILabel!
    @IBOutlet weak var TodoNotesIcon: UIImageView!
    @IBOutlet weak var TodoLocationIcon: UIImageView!
    
    @IBOutlet weak var todoStatusWidth: NSLayoutConstraint!
    @IBOutlet weak var todoStatusLeading: NSLayoutConstraint!
    @IBOutlet weak var stackLeading: NSLayoutConstraint!
    
    @IBOutlet weak var taskTitle: UITextField!
    
    var isInEditingMode: Bool = false
    var titleIsInEditingMode: Bool = false
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        delegate?.checkmarkTapped1(sender: self)
    }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//           super.init(style: style, reuseIdentifier: reuseIdentifier)
//       }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        taskTitle.returnKeyType = .done
        taskTitle.clearButtonMode = .whileEditing
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
                    self.TodoStatus.setImage(nil, for: .normal)
            }, completion: { _ in
                self.todoStatusWidth.constant = 0
                self.todoStatusLeading.constant = 8
                self.stackLeading.constant = 8
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
                self.stackLeading.constant = 52
                
                delegate?.finishEditing1(sender: self)
                //self.isInEditingMode = false
                //self.TodoStatus.isEnabled = true
            }
            super.setEditing(editing, animated: animated)
        }
    }
    
}
