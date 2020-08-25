//
//  ProjectExpandableHeaderView.swift
//  CalDo
//
//  Created by Fabian Jaeger on 8/25/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ProjectExpandableHeaderView, section: Int)
}

class ProjectExpandableHeaderView: UITableViewHeaderFooterView {
    
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (selectHeaderView)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (selectHeaderView)))
    }
    
    @objc func selectHeaderView(gesture: UITapGestureRecognizer) {
        let cell = gesture.view as! ProjectExpandableHeaderView
        delegate?.toggleSection(header:self, section: cell.section)
    }

    func customInit(title: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        self.headerLabel.text = title
        self.section = section
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.headerLabel.textColor = .textColor
    }

}
