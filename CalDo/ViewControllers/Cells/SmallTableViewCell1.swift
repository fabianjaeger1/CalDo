//
//  SmallTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 7/2/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class SmallTableViewCell1: UITableViewCell {
    
    @IBOutlet weak var TodoStatus: UIButton!
    @IBOutlet weak var TodoTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
