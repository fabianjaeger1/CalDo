//
//  AddTodoInboxViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 5/11/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit
import Foundation

class AddTodoInboxViewController: UIViewController {
    
    
    @IBOutlet weak var TodoTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TodoTitle.becomeFirstResponder()
        

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
