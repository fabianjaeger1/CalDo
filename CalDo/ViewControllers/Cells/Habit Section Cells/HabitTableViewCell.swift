//
//  HabitTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 10/25/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class HabitTableViewCell: UICollectionViewCell {
    
    @IBOutlet weak var habitTitle: UILabel!
    @IBOutlet weak var habitDescription: UILabel!
    @IBOutlet weak var habitImage: UIImageView!
    @IBOutlet weak var habitButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
