//
//  HabitDateSelectorCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 11/13/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

protocol HabitDateSelectorCellDelegate {
    func selectDate()
}

class HabitDateSelectorCell: UICollectionViewCell {
    
    @IBOutlet weak var Datelabel: UILabel!
    @IBOutlet weak var Date: UILabel!
    
    override var isHighlighted: Bool {
            didSet {
                self.contentView.backgroundColor = isHighlighted ? UIColor.BlueSelectorColor : nil
                self.Date.textColor = isHighlighted ? UIColor.white : UIColor.systemGray2
            }
        }
    
//    override var isSelected: Bool {
//           didSet {
//               if isSelected {
//                   Datelabel!.textColor = UIColor.green
//                   Date.font = UIFont.boldSystemFont(ofSize: 14)
//               } else {
//                   dateLabel!.textColor = UIColor.darkText
//                   dateLabel.font = UIFont.systemFont(ofSize: 14)
//               }
//           }
//       }
    
    
}
