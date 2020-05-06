//
//  TodoSectionCollectionViewCell.swift
//  
//
//  Created by Fabian Jaeger on 12.09.19.
//

import UIKit


class TodoSectionCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var TodoAmountLabel: UILabel!
    @IBOutlet weak var TodoSection: UIImageView!
    @IBOutlet weak var TodoSectionLabel: UILabel!
    
    
    func shrink(down: Bool) {
        UIView.animate(withDuration: 0.5) {
            if down {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                self.transform = CGAffineTransform(translationX: 0, y: 10)
            }
            else {
                self.transform = .identity
                self.layer.cornerRadius = 20
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet{
            shrink(down: isHighlighted)
        }
    }
    
    
}
