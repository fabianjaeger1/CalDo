//
//  OnDateRepeatViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 01.09.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit
import DayDatePicker

struct OnDateRepeat {
    var DateString: String?
    var Date: Date?
}


protocol OnDateRepeatDelegate {
    func didSelectDate(date: OnDateRepeat)
    
}





class OnDateRepeatViewController: UIViewController, DayDatePickerViewDelegate{
    
    
    var delegate: OnDateRepeatDelegate?
    
    
    // DayDatePickerDelegate Method
    
    func didSelectDate(day: NSInteger, month: NSInteger, year: NSInteger) {
        RepeatEndLabel.text! = "\(day) \(month) \(year)"

    }

    

    @IBOutlet weak var DayPicker: DayDatePickerView!
    
    
    let dateformatter = DateFormatter()
    
    
    func labelText(date: Date) -> (String){
        dateformatter.dateFormat = "MMMM d, YYYY"
        var textToDisplay: String?
        let today = Date()
        let todayinterval = today.timeIntervalSinceReferenceDate
        let dateinterval = date.timeIntervalSinceReferenceDate
        if dateinterval > todayinterval{
            textToDisplay = "On \(dateformatter.string(from: date))"
            RepeatEndLabel.textColor = UIColor(hexString: "5C9EED")
        }
        else {
            textToDisplay = "Ended on \(dateformatter.string(from: date))"
            RepeatEndLabel.textColor = UIColor(hexString: "ED5F55")
        }
        return textToDisplay!
    
    }
    
    @IBOutlet weak var RepeatEndLabel: UILabel!

    @IBAction func DateChange(_ sender: Any) {
        RepeatEndLabel.text! = labelText(date: DayPicker.date.date)
        var SelectedDate: OnDateRepeat?
        SelectedDate?.Date = DayPicker.date.date
        SelectedDate?.DateString = dateformatter.string(from: DayPicker.date.date)
        print(SelectedDate?.DateString!)
    
        // prints nill, issue with optional most likely
        delegate?.didSelectDate(date: SelectedDate!)
        
    }
    
    override func viewDidLoad() {
        
            dateformatter.dateFormat = "MMMM d, YYYY"
        
            DayPicker.hasHapticFeedback = true
            DayPicker.hasSound = false
            DayPicker.textFont = UIFont(name: "HelveticaNeue-Medium", size: 16)!
            DayPicker.textColor = UIColor.darkGray
        
        
        DayPicker.layer.borderColor = UIColor.green.cgColor
            
            DayPicker.overlayView.layer.cornerRadius = 20
            DayPicker.overlayView.layer.backgroundColor = UIColor(hexFromString: "5C9EED", alpha:1).cgColor
        
        
//        DatePicker.layer.backgroundColor = UIColor(hexString: "222831").cgColor
//        DatePicker.layer.cornerRadius = 20
//        DatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        DayPicker.layer.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor
        DayPicker.layer.cornerRadius = 20

        RepeatEndLabel.textColor = UIColor(hexString: "5C9EED")
        dateformatter.dateFormat = "MMMM dd YYYY"
        
        RepeatEndLabel.text = "Ended on \(dateformatter.string(from: Date()))"
//        DayPicker.setDate(Date(), animated: false)
        
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
