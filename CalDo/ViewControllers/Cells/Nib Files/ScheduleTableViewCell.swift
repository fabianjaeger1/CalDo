//
//  ScheduleTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 12/18/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewDetailLabel: UILabel!
    @IBOutlet weak var tableViewTitle: UILabel!
    @IBOutlet weak var tableViewImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
