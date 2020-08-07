//
//  SmallTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 06.08.20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

@objc protocol SmallTaskTableViewCellDelegate: class {
    func checkmarkTapped(sender: SmallTaskTableViewCell)
}


class SmallTaskTableViewCell: UITableViewCell {
    
    weak var delegate: SmallTaskTableViewCellDelegate?
    

    @IBOutlet weak var TodoStatus: UIButton!
    @IBOutlet weak var TodoTitle: UILabel!
    @IBOutlet weak var TodoDate: UILabel!
    @IBOutlet weak var TodoNotesIcon: UIImageView!
    @IBOutlet weak var TodoLocationIcon: UIImageView!
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        print("Test")
        delegate?.checkmarkTapped(sender: self)
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
