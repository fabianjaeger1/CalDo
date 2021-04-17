//
//  CustomTabBarViewController.swift
//  CustomTabBar
//
//  Created by Adam Bardon on 07/03/16.
//  Copyright © 2016 Swift Joureny. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController, CustomTabBarDataSource, CustomTabBarDelegate {
    
    let feedback = UIImpactFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bottom = self.view.frame.maxY - 70// will return the bottommost y coordinate of the view
        self.tabBar.frame = CGRect( x: 0, y: bottom, width: self.tabBar.frame.width, height: self.tabBar.frame.height)
        
        // Do any additional setup after loading the view.
        self.tabBar.isHidden = true
        
        let customTabBar = CustomTabBar(frame: self.tabBar.frame)
        customTabBar.datasource = self
        customTabBar.delegate = self
        customTabBar.viewController = self
        customTabBar.setup()
        
        self.view.addSubview(customTabBar)
    }
    
    // MARK: - CustomTabBarDataSource
    
    func tabBarItemsInCustomTabBar(tabBarView: CustomTabBar) -> [UITabBarItem] {
        return tabBar.items!
    }
    
    // MARK: - CustomTabBarDelegate
    
    func didSelectViewController(tabBarView: CustomTabBar, atIndex index: Int) {
        self.selectedIndex = index
        feedback.impactOccurred()
    }

}

