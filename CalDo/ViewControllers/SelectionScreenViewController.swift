//
//  SelectionScreenViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 27.07.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit


let rect = CGRect(x: 10, y: 10, width: 100, height: 100)
let myView = UIView(frame: rect)

class SelectionScreenViewController: UIViewController {
    
    @IBOutlet weak var CreateProjectButton: UIButton!
    @IBOutlet weak var CreateTaskButton: UIButton!
    @IBOutlet weak var CreateEventButton: UIButton!
    
    @IBOutlet weak var ProjectIconView: UIImageView!
    @IBOutlet weak var EventIconView: UIImageView!
    @IBOutlet weak var TaskIconView: UIImageView!
    
    
    @IBAction func RemoveButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func TaskButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "TaskCreateButtonPressed", sender: self)
//        let selection = self.presentingViewController
//        selection!.dismiss(animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CreateTaskButton.layer.shadowOpacity = 0.15
        CreateTaskButton.layer.cornerRadius = 20
        CreateTaskButton.layer.shadowRadius = 10
        CreateTaskButton.layer.shadowColor = UIColor.darkGray.cgColor
        
        CreateProjectButton.layer.shadowOpacity = 0.15
        CreateProjectButton.layer.cornerRadius = 20
        CreateProjectButton.layer.shadowRadius = 10
        CreateProjectButton.layer.shadowColor = UIColor.darkGray.cgColor
        
        CreateEventButton.layer.shadowOpacity = 0.15
        CreateEventButton.layer.cornerRadius = 20
        CreateEventButton.layer.shadowRadius = 10
        CreateEventButton.layer.shadowColor = UIColor.darkGray.cgColor
        
//        ProjectIconView.layer.applySketchShadow(
//            color: .black,
//            alpha: 0.5,
//            x: 0,
//            y: 0,
//            blur: 50,
//            spread: 2)
//        EventIconView.layer.applySketchShadow(
//            color: .black,
//            alpha: 0.5,
//            x: 0,
//            y: 0,
//            blur: 50,
//            spread: 2)
//        TaskIconView.layer.applySketchShadow(
//            color: .black,
//            alpha: 0.5,
//            x: 0,
//            y: 0,
//            blur: 50,
//            spread: 2
//        )
      
 
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
