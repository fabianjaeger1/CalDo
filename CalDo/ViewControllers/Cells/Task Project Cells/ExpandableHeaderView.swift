//
//  ProjectExpandableHeaderView.swift
//  CalDo
//
//  Created by Fabian Jaeger on 8/25/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

//extension UIView {
//   func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
//    let animation = CABasicAnimation(keyPath: "transform.scale.x”)
//      animation.toValue = toValue
//      animation.duration = duration
//      animation.isRemovedOnCompletion = false
//        animation.fillMode = CAMediaTimingFillMode.forwards
//      self.layer.add(animation, forKey: nil)
//   }
//}

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    
    var delegate: ExpandableHeaderViewDelegate?
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        print("Test")
    }
    

    


    var section: Int!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
        
        // deprecated
        //self.contentView.backgroundColor = UIColor.BackgroundColor
        //self.view.backgroundColor = UIColor.BackgroundColor
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .BackgroundColor
        self.backgroundView = backgroundView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.arrowImage.transform = CGAffineTransform(rotationAngle: 0.0)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String{
        return String(describing: self)
    }
    
    func setCollapsed(collapsed: Bool) {
        if collapsed == true {
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundView?.backgroundColor = .backgroundColor
                self.arrowImage.transform = self.arrowImage.transform.rotated(by: .pi / 2)
            })
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundView?.backgroundColor = .BackgroundColor
                self.arrowImage.transform = self.arrowImage.transform.rotated(by: -.pi / 2)
            })
        }
    }
    
    @objc private func didTapHeader() {
    
//        if isCollapsed == true {
////            arrowImage.rotate()
//            UIView.animate(withDuration: 2.0, animations: {
//                self.backgroundColor = UIColor.backgroundColor
//                self.arrowImage.transform = self.arrowImage.transform.rotated(by: .pi / 2)
//                //self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(-.pi/2.0))
//            })
//        }
//        else {
////            arrowImage.rotate()
//            UIView.animate(withDuration: 2.0, animations: {
//                self.backgroundColor = UIColor.BackgroundColor
//                self.arrowImage.transform = self.arrowImage.transform.rotated(by: -.pi / 2)
//                //self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(.pi/2.0))
//            })
////            arrowImage.transform = arrowImage.transform.rotated(by: -.pi/2)
//        }
        delegate?.toggleSection(header: self, section: section)
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
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: 0.4*Double.pi )
         rotation.duration = 1
         rotation.isCumulative = true
         rotation.repeatCount = Float.greatestFiniteMagnitude
         self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
