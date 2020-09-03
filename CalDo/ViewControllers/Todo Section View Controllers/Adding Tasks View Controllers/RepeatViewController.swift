//
//  RepeatViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 30.08.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit

class RepeatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var selectedIndexes = [IndexPath.init(row: 0, section: 0)]
    
    var repeatAfterCompletion: Bool = false
    
    @IBOutlet weak var EndRepeatButton: UIButton!
    
    
    @IBAction func EndRepeatButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "EndRepeat", sender: self)
    }
    
    @IBOutlet weak var RepeatAfterCompletionSwitch: UISwitch!
    
    @IBAction func RepeatAfterCompletionSwitchChanged(_ sender: Any) {
        repeatAfterCompletion = RepeatAfterCompletionSwitch.isOn
        print(repeatAfterCompletion)
    }
    @IBOutlet weak var RepeatLabel: UILabel!
    @IBOutlet weak var BackgroundView1: UIView!
    @IBOutlet weak var BackgroundView2: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let titles = ["Never", "Daily", "Weekly", "Every 2 Weeks", "Monthly"]
    
    func labelTextes(Title:String) -> (String){
        var textToDisplay: String?
        switch(Title) {
        case "Never":
            textToDisplay = "Never"
        case "Daily":
            textToDisplay = "Every Day"
        case "Weekly":
            textToDisplay = "Every Week"
        case "Every 2 Weeks":
            textToDisplay = "Every 2 Weeks"
        case "Monthly":
            textToDisplay = "Monthly"
        default:
            textToDisplay = "Never"
        }
        return textToDisplay!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatViewCell", for: indexPath) as! RepeatViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear

        cell.tintColor = UIColor(hexString: "5C9EED")
        cell.textLabel?.text = titles[indexPath.row]
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        cell.textLabel?.textColor = UIColor(hexString: "A5ADB8")
//        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
        
        if selectedIndexes.contains(indexPath) {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.black
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if !self.selectedIndexes.contains(indexPath) {
            // mark it checked
            cell?.accessoryType = .checkmark
//            cell?.textLabel!.textColor = UIColor(hexString: "3E464F")
            
            //Attempted to change color for selected index Path cell
            
            // Remove any previous selected indexpath
            self.selectedIndexes.removeAll()
            
            // add currently selected indexpath
            self.selectedIndexes.append(indexPath)
            RepeatLabel.text = labelTextes(Title: (cell?.textLabel?.text!)!)
            
            tableView.reloadData()
        }
    }
    

    @IBOutlet weak var BackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        BackgroundView.layer.cornerRadius = 30

        // Do any additional setup after loading the view.
        
        BackgroundView1.layer.cornerRadius
            = 20
        BackgroundView1.layer.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor
        BackgroundView1.layer.cornerRadius = 20
        
        BackgroundView2.layer.cornerRadius = 20
        BackgroundView2.layer.backgroundColor =
            UIColor(hexFromString: "F0F2F4", alpha: 1.0).cgColor
//        tableView.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6)
        tableView.layer.masksToBounds = true
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        tableView.layer.backgroundColor =
        UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor
//        tableView.layer.backgroundColor =
//        UIColor(hexFromString: "F0F2F4", alpha: 0.8).cgColor
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EndRepeat"{
            let secondVC = segue.destination as! EndRepeatViewController
            
        }
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
