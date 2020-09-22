//
//  InboxHomeScreenTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 11.09.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit

protocol InboxCellDelegate: class {
    func checkmarkTapped(sender: InboxHomeScreenTableViewCell)
}

class InboxHomeScreenTableViewCell: UITableViewCell {
    
    weak var delegate: InboxCellDelegate?

    @IBOutlet weak var TodoTitle: UILabel!
    @IBOutlet weak var TodoStatus: UIButton!
    
    @IBOutlet weak var ProjectColor: UIView!
    @IBOutlet weak var ProjectLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        delegate?.checkmarkTapped(sender: self)
    }
    
//    func shrink(down: Bool) {
//        UIView.animate(withDuration: 0.5) {
//            if down {
//                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                //                self.transform = CGAffineTransform(translationX: 0, y: 10)
//            }
//            else {
//                self.transform = .identity
//            }
//        }
//    }
//    
//    
//    override var isHighlighted: Bool {
//        didSet{
//            shrink(down: isHighlighted)
//            print("Test")
//        }
//    }
//  
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
