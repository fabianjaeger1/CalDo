//
//  SmallTableViewCell2.swift
//  CalDo
//
//  Created by Fabian Jaeger on 7/2/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class SmallTableViewCell2: UITableViewCell {
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
