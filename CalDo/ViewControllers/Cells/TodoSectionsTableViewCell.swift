//
//  TodoSectionsTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 11.09.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit

class TodoSectionsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var TodoLabel: UILabel!
    @IBOutlet weak var TodoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
