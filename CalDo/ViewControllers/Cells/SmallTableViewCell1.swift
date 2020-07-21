//
//  SmallTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 7/2/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

@objc protocol ToDoCellDelegate1: class {
    func checkmarkTapped(sender: SmallTableViewCell1)
}


class SmallTableViewCell1: UITableViewCell {
    
    var delegate: ToDoCellDelegate1?
    
    @IBOutlet weak var TodoStatus: UIButton!
    @IBOutlet weak var TodoTitle: UILabel!
    @IBOutlet weak var TodoDate: UILabel!
    
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
