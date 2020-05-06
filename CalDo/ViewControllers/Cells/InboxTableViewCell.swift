//
//  InboxTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 27.07.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit

@objc protocol ToDoCellDelegate: class {
    func checkmarkTapped(sender: InboxTableViewCell)
}

class InboxTableViewCell: UITableViewCell{
    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//    }
//    
    
    var delegate: ToDoCellDelegate? //inform cell
    
    @IBOutlet weak var Tag1: UILabel!
    @IBOutlet weak var Tag2: UILabel!
    @IBOutlet weak var Tag3: UILabel!
    @IBOutlet weak var Tag4: UILabel!
    @IBOutlet weak var Tag5: UILabel!
    
    @IBOutlet weak var ProjectLabel: UILabel!
    @IBOutlet weak var ProjectColor: UIView!
    @IBOutlet weak var TodoStatus: UIButton!
    @IBOutlet weak var TodoTitle: UILabel!
    @IBOutlet weak var TodoDate: UILabel!
    @IBOutlet weak var TodoNotesIcon: UIImageView!
    @IBOutlet weak var TodoLocationIcon: UIImageView!
    
    
    
    
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
