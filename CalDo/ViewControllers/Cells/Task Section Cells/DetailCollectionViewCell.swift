//
//  DetailCollectionViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 10/9/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func shrink(down: Bool) {
        UIView.animate(withDuration: 0.5) {
            if down {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                self.transform = CGAffineTransform(translationX: 0, y: 10)
            }
            else {
                self.transform = .identity
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet{
            shrink(down: isHighlighted)
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
