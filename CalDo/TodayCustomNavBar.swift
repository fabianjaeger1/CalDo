//
//  TodayCustomNavBar.swift
//  CalDo
//
//  Created by Fabian Jaeger on 15.09.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit

class TodayCustomNavBar: UINavigationBar {
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
        
            
            for subview in subviews {
                
                    if let largeTitleLabel = subview.subviews.first(where: { $0 is UILabel }) as? UILabel {
                        let largeTitleView = subview
                        print("largeTitleView:", largeTitleView)
                        print("largeTitleLabel:", largeTitleLabel)
                        // you may customize the largeTitleView and largeTitleLabel here
                        break
                    }
                }
            }
        }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
/Users/fabianjaeger/Developer/CalDo/CalDo/ViewControllers/Cells/TodayCustomNavBar.swift    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

