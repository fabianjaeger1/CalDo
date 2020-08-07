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
}

//protocol TaskCellDelegate: class{
//    func checkmarkTapped(sender: )
//}

class TaskTableViewCell: UITableViewCell {
    
     weak var delegate: TaskTableViewCellDelegate?
    
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
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        print("Test")
        delegate?.checkmarkTapped1(sender: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
