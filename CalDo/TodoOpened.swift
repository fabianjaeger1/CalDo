//
//  TodoOpened.swift
//  CalDo
//
//  Created by Fabian Jaeger on 23.10.17.
//  Copyright © 2017 CalDo. All rights reserved.
//

import UIKit

class TodoOpened: UIViewController {

    var todoName = String()
    
    @IBOutlet weak var TodoOpenedLabel: UILabel!
    @IBOutlet weak var BackButton: UIButton!
    @IBAction func BackButtonPressed(_ sender: Any) {
        dismiss(animated:true,completion: nil)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        TodoOpenedLabel.text = todoName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
