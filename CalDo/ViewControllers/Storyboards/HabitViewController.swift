//
//  HabitViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 10/23/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class HabitViewController: UIViewController {
    
    @IBOutlet weak var ProgressBar: PlainCircularProgressBar!
    
    @IBOutlet weak var ProgressLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!

    @IBAction func ProgressChanged(_ sender: UISlider) {
        let progress = CGFloat(sender.value)
        let progressNumber = NSNumber(value: Float(progress))
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        let progresslabel = numberFormatter.string(from: progressNumber)
        ProgressLabel.text = progresslabel! + " Done"
        ProgressBar.progress = progress
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressLabel.textColor = UIColor.gray

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

