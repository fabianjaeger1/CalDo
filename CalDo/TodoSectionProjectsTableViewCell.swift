//
//  TodoSectionProjectsTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 15.09.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit

class TodoSectionProjectsTableViewCell: UITableViewCell {

    @IBOutlet weak var ProjectColor: UIView!
    @IBOutlet weak var ProjectLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
