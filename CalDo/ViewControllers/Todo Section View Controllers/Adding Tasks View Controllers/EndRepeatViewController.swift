//
//  EndRepeatViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 31.08.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit

class EndRepeatViewController: UIViewController {
    
    let segmentedControl = UISegmentedControl()
    let buttonBar = UIView()
    // Delegate sending the information back to the the Repeat VC
    
    private var OnDateRepeatVC: OnDateRepeatViewController?
    private var RepetitionVC: RepetitionViewController?
    
    @IBOutlet weak var BackgroundView: UIView!
    
    @IBOutlet weak var RepeatSelect: UIView!
    @IBOutlet weak var OnDateView: UIView!
    @IBOutlet weak var NeverView: UIView!
    @IBOutlet weak var RepetitionView: UIView!
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        

//        guard let OnDate = children.first as? OnDateRepeatViewController else  {
//            fatalError("Check storyboard for missing LocationTableViewController")
//        }
//        
//        guard let Repetition = children.last as? RepetitionViewController else {
//            fatalError("Check storyboard for missing MapViewController")
//        }
        
//        OnDateRepeatVC = OnDate
//        RepetitionVC = Repetition
//        OnDate.delegate = self
        
        let font = UIFont(name: "Helvetica-Bold", size: 17)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
        
        BackgroundView.layer.cornerRadius = 20
        BackgroundView.layer.shadowColor = UIColor.darkGray.cgColor
        BackgroundView.layer.shadowOpacity = 20
        BackgroundView.layer.shadowOpacity = 0.4
        NeverView.layer.backgroundColor = UIColor.white.cgColor
        OnDateView.layer.backgroundColor = UIColor.white.cgColor

        
        
        segmentedControl.addTarget(self, action: #selector(self.switchViews(_:)), for: .valueChanged)
        segmentedControl.insertSegment(withTitle: "Never", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "On Date", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Repetitions", at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        RepeatSelect.addSubview(segmentedControl)
        segmentedControl.leftAnchor.constraint(equalTo: RepeatSelect.leftAnchor).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: RepeatSelect.rightAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: RepeatSelect.topAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: RepeatSelect.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        (segmentedControl.subviews[2] as UIView).tintColor = UIColor(hexString: "3E464F")
        (segmentedControl.subviews[1] as UIView).tintColor = UIColor(hexString: "3E464F")
        (segmentedControl.subviews[0] as UIView).tintColor = UIColor(hexString: "3E464F")

        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
    
        segmentedControl.removeBorders()

        // ---------------- BUTTON BAR (BAR BELOW THE PIORTITY LABELS) -----------------

        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor(hexString: "4FC2E8")

        RepeatSelect.addSubview(buttonBar)

        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        buttonBar.layer.cornerRadius = 2
        buttonBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        buttonBar.leftAnchor.constraint(equalTo: RepeatSelect.leftAnchor).isActive = true
        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)

        RepeatSelect.layer.backgroundColor = UIColor.clear.cgColor




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
    
    @IBAction func switchViews(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            NeverView.alpha = 1
            OnDateView.alpha = 0
            RepetitionView.alpha = 0
            
        }
        else if sender.selectedSegmentIndex == 1 {
            OnDateView.alpha = 1
            NeverView.alpha = 0
            RepetitionView.alpha = 0
        }
        else {
            RepetitionView.alpha = 1
            NeverView.alpha = 0
            OnDateView.alpha = 0
        }
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.2) {
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            
        }
    }
}
