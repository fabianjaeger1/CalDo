//
//  RepetitionViewController.swift
//  
//
//  Created by Fabian Jaeger on 01.09.19.
//

import UIKit

class RepetitionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var RepetionLabel: UILabel!
    
    let i = 0
    let Repetions = ["1 Repetition", "2 Repetitions", "3 Repetitions", "4 Repetitions", "5 Repetitions", "6 Repetitions", "7 Repetitions", "8 Repetitions", "9 Repetitions", "10 Repetitions", "11 Repetitions", "12 Repetitions", "13 Repetitions", "14 Repetitions", "14 Repetitions", "15 Repetitions", "16 Repetitions", "17 Repetitions", "18 Repetitions", "19 Repetitions", "20 Repetitions", "21 Repetitions", "22 Repetitions", "23 Repetitions", "24 Repetitions", "25 Repetitions", "26 Repetitions", "27 Repetitions", "28 Repetitions", "29 Repetitions", "30 Repetitions", "31 Repetitions", "32 Repetitions", "33 Repetitions", "34 Repetitions", "35 Repetitions", "36 Repetitions", "10 Repetitions", "11 Repetitions", "12 Repetitions", "13 Repetitions", "14 Repetitions", "14 Repetitions", "2 Repetitions", "3 Repetitions", "4 Repetitions", "5 Repetitions", "6 Repetitions", "7 Repetitions", "8 Repetitions", "9 Repetitions", "10 Repetitions", "11 Repetitions", "12 Repetitions", "13 Repetitions", "14 Repetitions", "14 Repetitions",   ]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Repetions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Repetions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        RepetionLabel.text! = "Task will repeat \(String(row)) times"
        RepetitionPicker.setValue(UIColor.blue, forKeyPath: "textColor")
    }

    @IBOutlet weak var RepetitionPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RepetitionPicker.layer.cornerRadius = 20
        self.RepetitionPicker.delegate = self
        self.RepetitionPicker.dataSource = self
    
        RepetitionPicker.layer.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor

        // Do any additional setup after loading the view.
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        
        // where data is an Array of String
        label.text = Repetions[row]
        
        
        return label
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
