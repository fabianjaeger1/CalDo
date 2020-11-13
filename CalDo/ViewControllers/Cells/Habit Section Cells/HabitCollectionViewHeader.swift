//
//  HabitCollectionViewHeader.swift
//  CalDo
//
//  Created by Fabian Jaeger on 11/13/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class HabitCollectionViewHeader: UICollectionReusableView {
    static let identifier = "HabitCollectionViewHeader"
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var image: UIImageView!
    
    
//       override func prepareForReuse() {
//    //        super.prepareForReuse()
//    //        self.arrowImage.transform = CGAffineTransform(rotationAngle: 0.0)
//    }
    
    
//    func setCollapsed(collapsed: Bool) {
  //        if collapsed == true {
  //            UIView.animate(withDuration: 0.2, animations: {
  //                self.view.backgroundColor = UIColor.backgroundColor
  //                self.arrowImage.transform = self.arrowImage.transform.rotated(by: .pi / 2)
  //            })
  //        }
  //        else {
  //            UIView.animate(withDuration: 0.2, animations: {
  //                self.view.backgroundColor = UIColor.BackgroundColor
  //                self.arrowImage.transform = self.arrowImage.transform.rotated(by: -.pi / 2)
  //            })
  //        }
  //    }
      
  //    @objc private func didTapHeader() {
  //        delegate?.toggleSection(header: self, section: section)
//      }
    
    static func nib() -> UINib {
        return UINib(nibName: "HabitCollectionViewHeader", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
