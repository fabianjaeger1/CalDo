//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by Adam Bardon on 07/03/16.
//  Copyright © 2016 Swift Joureny. All rights reserved.
//

import UIKit


protocol CustomTabBarDataSource {
    func tabBarItemsInCustomTabBar(tabBarView: CustomTabBar) -> [UITabBarItem]
}

protocol CustomTabBarDelegate {
    func didSelectViewController(tabBarView: CustomTabBar, atIndex index: Int)
}

class CustomTabBar: UIView {
    
    var SelectedImages = ["HomeSelected","CalendarSelected","TodoSelected","AccountSelected"]
    // still find way to implement selected states
    
    var datasource: CustomTabBarDataSource!
    var delegate: CustomTabBarDelegate!
    var viewController: UIViewController!
    
    var tabBarItems: [UITabBarItem]!
    var customTabBarItems: [CustomTabBarItem]!
    var tabBarButtons: [UIButton]!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if #available(iOS 13.0, *) {
            self.backgroundColor = .BackgroundColor
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        // get tab bar items from default tab bar
        tabBarItems = datasource.tabBarItemsInCustomTabBar(tabBarView: self)
        
        customTabBarItems = []
        tabBarButtons = []
        
        let containers = createTabBarItemContainers()
        createTabBarItems(containers: containers)
    }
    
    
    func createTabBarItems(containers: [CGRect]) {
        for i in 0..<tabBarItems.count {
            let container = containers[i]
            
            let customTabBarItem = CustomTabBarItem(frame: container)
            customTabBarItem.setup(item: tabBarItems[i])
            
            self.addSubview(customTabBarItem)
            customTabBarItems.append(customTabBarItem)
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: container.width, height: container.height))
            button.addTarget(self, action: #selector(CustomTabBar.barItemTapped(sender:)), for: UIControl.Event.touchUpInside)
            
            customTabBarItem.addSubview(button)
            tabBarButtons.append(button)
        }
        
        // add plus button
        
        let plusRect = createCenterTabBarContainer()
        let button = UIButton(frame: plusRect)
        
//        let button = CircleMenu(
//             frame: CGRect(x: 200, y: 200, width: 50, height: 50),
//             normalIcon:"icon_menu",
//             selectedIcon:"icon_close",
//             buttonsCount: 4,
//             duration: 4,
//             distance: 120)
//           button.delegate = self
//           button.layer.cornerRadius = button.frame.size.width / 2.0
//           CustomTabBar.addSubview(button)
//
        button.setImage(UIImage(named: "Add"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(CustomTabBar.centerButtonPress), for: UIControl.Event.touchUpInside)
        addSubview(button)
    }
    
    func createTabBarItemContainers() -> [CGRect] {
        if tabBarItems.count != 4 {
            fatalError("This tab bar only supports 4 views and one plus button!!")
        }
        var containerArray = [CGRect]()
        
        // create container for each tab bar item
        for i in 0..<tabBarItems.count + 1 {
            if i == tabBarItems.count / 2 {
                // (+) button, ignore
            } else {
                let tabBarContainer = createTabBarContainer(index: i)
                containerArray.append(tabBarContainer)
            }
            
        }
        
        return containerArray
    }
    
    func createTabBarContainer(index: Int) -> CGRect {
        
        let tabBarContainerWidth = self.frame.width / CGFloat(tabBarItems.count+1)
        let tabBarContainerRect = CGRect(x: tabBarContainerWidth * CGFloat(index), y: 0 - 10, width: tabBarContainerWidth, height: self.frame.height)
        
        return tabBarContainerRect
    }
    
    func createCenterTabBarContainer() -> CGRect {
        
        let w = self.frame.height * 2
        
        let tabBarContainerRect = CGRect(x: self.frame.width/2-w/2, y: self.bounds.height/2-w/2 - 10, width: w, height: w)
        
        
        return tabBarContainerRect
    }
    
    @objc func barItemTapped(sender : UIButton) {
        let index = tabBarButtons.firstIndex(of: sender)!
        tabBarButtons[index].setImage(UIImage(named: SelectedImages[index]), for: .selected)
        delegate.didSelectViewController(tabBarView: self, atIndex: index)
    }
    
    
    @objc func centerButtonPress(){
        UIView.animate(withDuration: 6){
            
        }
        let viewController : SelectionScreenViewController = self.viewController.storyboard!.instantiateViewController(withIdentifier: "SelectionScreenViewController") as! SelectionScreenViewController
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        viewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.viewController.present(viewController, animated: true)
    }
}

