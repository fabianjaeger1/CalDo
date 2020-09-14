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
}


class SmallTaskTableViewCell: UITableViewCell {
    
    weak var delegate: SmallTaskTableViewCellDelegate?
    var myViewController: TaskTableViewController?

    @IBOutlet weak var TodoStatus: UIButton!
    @IBOutlet weak var TodoTitle: UILabel!
    @IBOutlet weak var TodoDate: UILabel!
    @IBOutlet weak var TodoNotesIcon: UIImageView!
    @IBOutlet weak var TodoLocationIcon: UIImageView!
    
    @IBOutlet weak var todoStatusWidth: NSLayoutConstraint!
    @IBOutlet weak var todoStatusLeading: NSLayoutConstraint!
    
    var isInEditingMode: Bool = false
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        print("Test")
        delegate?.checkmarkTapped(sender: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
