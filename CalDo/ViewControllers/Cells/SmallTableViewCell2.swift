//
//  SmallTableViewCell2.swift
//  CalDo
//
//  Created by Fabian Jaeger on 7/2/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

@objc protocol ToDoCellDelegate2: class {
    func checkmarkTapped(sender: SmallTableViewCell2)
}

class SmallTableViewCell2: UITableViewCell {
    
    var delegate: ToDoCellDelegate2? 
    
    @IBOutlet weak var ProjectColor: UIView!
    @IBOutlet weak var ProjectLabel: UILabel!
    
    @IBOutlet weak var TodoStatus: UIButton!
    @IBOutlet weak var TodoTitle: UILabel!
    
    @IBOutlet weak var TodoNotesIcon: UIImageView!
    @IBOutlet weak var TodoLocationIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        delegate?.checkmarkTapped(sender: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
