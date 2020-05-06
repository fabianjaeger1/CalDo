//
//  NewThingViewController.swift
//  CalDo
//
//  Created by Julius Naeumann on 10/8/17.
//  Copyright © 2017 CalDo. All rights reserved.
//

import Foundation
import UIKit


class NewThingViewController : UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var Input: UITextField!
    
    @IBAction func AddItem(_ sender: Any) {
        if (Input.text != "")
        {
            list.append(Input.text!)
            Input.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = UIModalPresentationStyle.currentContext
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let swipeRecognizer : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(NewThingViewController.swipeDown(sender:)))
        swipeRecognizer.direction = UISwipeGestureRecognizer.Direction.down;
        view.addGestureRecognizer(swipeRecognizer)
        
        mainView.layer.shadowOpacity = 0.15
        mainView.layer.cornerRadius = 20
        mainView.layer.shadowRadius = 5
        mainView.layer.shadowColor = UIColor.black.cgColor
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnDonePress(_ sender: Any) {
        dismiss(animated: true, completion: {()->Void in
            print("done");
        });
    }
    
    @objc func swipeDown(sender: UIGestureRecognizer){
        dismiss(animated: true, completion: {()->Void in
            print("done");
        });
    }
    
}


