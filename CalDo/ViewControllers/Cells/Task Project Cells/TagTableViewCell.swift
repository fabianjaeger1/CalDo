//
//  TagsTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 9/14/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tagTitle: UILabel!
    @IBOutlet weak var tagIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
