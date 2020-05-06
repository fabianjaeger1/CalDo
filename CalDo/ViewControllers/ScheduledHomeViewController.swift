//
//  ScheduledHomeViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 11.09.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit
import StepIndicator

class ScheduledHomeViewController: UIViewController {
    
    let stepIndicatorView = StepIndicatorView()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.BackgroundColor
    
        self.stepIndicatorView.frame = CGRect(x: 0, y: 30, width: 100, height: 300)
        
        //Let Height of step indicator View be equal to the height of the table view
        self.tableView.addSubview(self.stepIndicatorView)
        self.tableView.backgroundColor = UIColor.clear
        
        self.stepIndicatorView.numberOfSteps = 5
        self.stepIndicatorView.currentStep = 1
        self.stepIndicatorView.direction = .topToBottom
        self.stepIndicatorView.lineMargin = 4.0
        self.stepIndicatorView.lineStrokeWidth = 2.0
        self.stepIndicatorView.lineColor = UIColor(hexFromString: "E1E4E7", alpha: 0.5)
        self.stepIndicatorView.lineTintColor = UIColor(hexFromString: "E1E4E7", alpha: 0.5)
        self.stepIndicatorView.circleTintColor = UIColor(hexString: "4FC2E8")
        self.stepIndicatorView.circleColor = UIColor(hexFromString: "4FC2E8", alpha: 0.4)
        self.stepIndicatorView.backgroundColor = UIColor.clear
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
