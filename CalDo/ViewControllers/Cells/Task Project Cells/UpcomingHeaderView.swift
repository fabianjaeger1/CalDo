//
//  UpcomingHeaderView.swift
//  CalDo
//
//  Created by Nathan Baudis  on 12/18/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import Foundation
import UIKit

class UpcomingHeaderView: UITableViewHeaderFooterView {
    
    
    @IBOutlet weak var sectionTitle: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String{
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .BackgroundColor
        self.backgroundView = backgroundView
        
        // self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
