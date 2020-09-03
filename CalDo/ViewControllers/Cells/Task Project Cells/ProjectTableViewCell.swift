//
//  ProjectTableViewCell.swift
//  CalDo
//
//  Created by Nathan Baudis  on 8/11/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import Foundation
import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var projectColor: UIView!
    @IBOutlet weak var projectLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
