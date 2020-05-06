//
//  TimePickerViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 31.07.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit


protocol SendTimeBackDelegate {
    
    func dataReceived(data: String)
    
}


extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}



class TimePickerViewController: UIViewController {
    
    
    var timePreviouslyPicked = ""


    
    var delegate: SendTimeBackDelegate?
    
    @IBOutlet weak var DateTimePicker: UIDatePicker!
    @IBOutlet weak var ScreenView: UIView!
    @IBOutlet weak var DoneButton: UIButton!
    
    
    //    let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
//    let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
//    let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
//    picker.frame = CGRect(x: 0, y: 100, width: picker.frame.size.width, height: picker.frame.size.height)
//    self.view.addSubview(picker)

//
    @IBAction func DoneButtonPressed(_ sender: Any) {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeStyle = .short
        let selectedTime = dateFormatter2.string(from: DateTimePicker.date)
        print(selectedTime)
    
        delegate?.dataReceived(data: selectedTime)
        dismiss(animated: true, completion: nil)
        
    }
    

    override func viewDidLoad() {
        
        DateTimePicker.backgroundColor = UIColor.darkGray
        DateTimePicker.setValue(UIColor.white, forKeyPath: "textColor")
        DateTimePicker.setValue(0.8, forKeyPath: "alpha")
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat =  "h:mm a"
//        let date1 = dateFormatter.date(from: "2.45 AM") // sent value from selected time
//        DateTimePicker.date = date1!
        
        
        ScreenView.layer.cornerRadius = 20
        ScreenView.backgroundColor = UIColor.darkGray
        DoneButton.layer.cornerRadius = 10
        ScreenView.layer.applySketchShadow(
            color: .black,
            alpha: 0.5,
            x: 0,
            y: 0,
            blur: 50,
            spread: 2)
        
       
        print(timePreviouslyPicked)
        
        if timePreviouslyPicked != "Add Time" {
            let dateformatter1 = DateFormatter()
            dateformatter1.timeStyle = .short
            let selecTimeinDate = dateformatter1.date(from: timePreviouslyPicked)
            DateTimePicker.date = selecTimeinDate!
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func CancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
