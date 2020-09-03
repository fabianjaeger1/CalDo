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
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var image: UIImageView!

    var section: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String{
        return String(describing: self)
    }
    
    @objc private func didTapHeader(){
        delegate?.toggleSection(header: self, section: section)
    }
    
    func setCollapsed(collapsed: Bool) {
        arrowImage?.rotate(collapsed ? 0.0: .pi)
    }
    
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (selectHeaderView)))
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (selectHeaderView)))
//    }
//
//    @objc func selectHeaderView(gesture: UITapGestureRecognizer) {
//        let cell = gesture.view as! ProjectExpandableHeaderView
//        delegate?.toggleSection(header:self, section: cell.section)
//    }
//
//    func customInit(title: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
//        self.headerLabel.text = title
//        self.section = section
//        self.delegate = delegate
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.headerLabel.textColor = .textColor
//    }

}

extension UIView{
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
}
