//
//  TaskButton.swift
//  CalDo
//
//  Created by Nathan Baudis  on 9/14/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import Foundation
import UIKit

class TaskButton: UIButton {
    var task: TaskEntity
    
    required init(task: TaskEntity) {
        self.task = task
        
        super.init(frame: .zero)
        
        switch(task.value(forKey: "recurrence") as! Bool, task.value(forKey: "priority") as! Int) {
        case (true, 0):
            let image = UIImage(named: "Recurring")
            self.setImage(image, for: .normal)
        case (true, 1):
            let image = UIImage(named: "Recurring Normal")
            self.setImage(image, for: .normal)
        case (true, 2):
            let image = UIImage(named: "Recurring High")
            self.setImage(image, for: .normal)
         case (false, 0):
            let image = UIImage(named: "TodoButton")
            self.setImage(image, for: .normal)
        case (false, 1):
            let image = UIImage(named: "Todo Medium Priority")
            self.setImage(image, for: .normal)
        case (false, 2):
            let image = UIImage(named: "Todo High Priority")
            self.setImage(image, for: .normal)
        default:
            print("Recurrence and/or priority outside of range")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImageFromTask(task: TaskEntity) {
        switch(task.value(forKey: "recurrence") as! Bool, task.value(forKey: "priority") as! Int) {
        case (true, 0):
            let image = UIImage(named: "Recurring")
            self.setImage(image, for: .normal)
        case (true, 1):
            let image = UIImage(named: "Recurring Normal")
            self.setImage(image, for: .normal)
        case (true, 2):
            let image = UIImage(named: "Recurring High")
            self.setImage(image, for: .normal)
         case (false, 0):
            let image = UIImage(named: "TodoButton")
            self.setImage(image, for: .normal)
        case (false, 1):
            let image = UIImage(named: "Todo Medium Priority")
            self.setImage(image, for: .normal)
        case (false, 2):
            let image = UIImage(named: "Todo High Priority")
            self.setImage(image, for: .normal)
        default:
            print("Recurrence and/or priority outside of range")
        }
    }
    
}
