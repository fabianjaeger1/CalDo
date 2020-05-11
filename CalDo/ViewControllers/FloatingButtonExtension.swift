//
//  FloatingButtonExtension.swift
//  CalDo
//
//  Created by Fabian Jaeger on 5/11/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

extension UIButton {
    func createFloatingActionButton() {
        backgroundColor = UIColor.gray
        layer.cornerRadius = frame.height / 2
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }
}
