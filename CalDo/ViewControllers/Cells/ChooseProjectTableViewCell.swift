//
//  ChooseProjectTableViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 29.07.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit

class ChooseProjectTableViewCell: UITableViewCell {
    
    var shapeLayer = CAShapeLayer()



    @IBOutlet weak var ColorView: UIView!
    @IBOutlet weak var ProjectLabel: UILabel!
    
//    override func layoutSubviews() {
//
//        let center = CGPoint(x: ColorView.frame.height/2, y: ColorView.frame.width/2)
//        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(6), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
//
//
//        shapeLayer.path = circlePath.cgPath
//        shapeLayer.lineWidth = 3.0
//        ColorView.layer.addSublayer(shapeLayer)
//    
// 
//    
//        
//    }


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
