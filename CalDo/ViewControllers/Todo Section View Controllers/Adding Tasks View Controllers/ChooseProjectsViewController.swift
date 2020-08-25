//
//  ChooseProjectsViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 29.07.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit

protocol ChooseProjectsViewControllerDelegate: class {
    func didSelect(ProjectSelected: Project)
    
    
    // Add index Path delegate

    // Did select, it has to be an object of type Project, therefore including Project Color and Project Label.
}

extension UIColor{
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }

    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

var PreviouslySelectedIndex: IndexPath?

// Extension that allows us to convert the stored Hex string in the project Struct into a UIColor value

class ChooseProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
    
    weak var delegate: ChooseProjectsViewControllerDelegate?
    
    var SelectedProject: Project?
    
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var UIProjectView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        //
        //        let center = CGPoint(x: ColorView.frame.height/2, y: ColorView.frame.width/2)
        //        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(6), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        //
        //
        //        shapeLayer.path = circlePath.cgPath
        //        shapeLayer.lineWidth = 3.0
        //        ColorView.layer.addSublayer(shapeLayer)
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseProjectTableViewCell", for: indexPath) as! ChooseProjectTableViewCell
        let Project = Projects[indexPath.row]
        cell.ProjectLabel?.text = Project.ProjectTitle
    
        let shapeLayer = CAShapeLayer()

        let center = CGPoint(x: cell.ColorView.frame.height/2, y: cell.ColorView.frame.width/2)
        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(6), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)

        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 3.0
        
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 3.0
        shapeLayer.fillColor = UIColor(hexString: Project.ProjectColor!).cgColor
        cell.ColorView.layer.addSublayer(shapeLayer)

        
        if indexPath == PreviouslySelectedIndex {
            let image = UIImage(named: "Checkmark")
            let imageView = UIImageView(image: image!)
            cell.accessoryView = imageView
            cell.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.8)
            cell.layer.cornerRadius = 20
        }
        else{
            
        }
        
//        cell.ColorView.layer.backgroundColor = UIColor.clear.cgColor
    
//        cell.ColorView.layer.backgroundColor = UIColor(hexString: Project.ProjectColor!).cgColor
//
//        let red = UIColor(red: 100.0/255.0, green: 130.0/255.0, blue: 0/255.0, alpha: 1.0)
//        cell.ProjectColorIndicator.layer.borderColor = red.cgColor
////        shapeLayer.fillColor = UIColor().HexToColor(hexString: Project.ProjectColor!, alpha: 1).cgColor
//        cell.ProjectColorIndicator.backgroundColor = .clear
//        cell.ProjectColorIndicator.backgroundColor = UIColor().HexToColor(hexString: Project.ProjectColor!, alpha: 1) ///// I FUCKING DID IT
    
//        if Project.ProjectTitle == Project.ProjectTitle{
//            cell.accessoryType = .checkmark
//        } else
//        {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    
        
//        let center = CGPoint(x: cell.ProjectColor.frame.height/2, y: cell.ProjectColor.frame.width/2)
//        let shapeLayer = CAShapeLayer()
//        let point = CGPoint(x: 0, y: 0)
//        let circlePath = UIBezierPath(arcCenter: point, radius: CGFloat(2), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
//
//        shapeLayer.path = circlePath.cgPath
//
//        //change the fill color
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        //        //you can change the stroke color
//        shapeLayer.strokeColor = UIColor.clear.cgColor
//        //you can change the line width
//        shapeLayer.lineWidth = 3.0
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Projects.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    
    
    override func viewDidLoad() {
        
//        if PreviouslySelectedIndex != nil{
//        tableView(tableView, cellForRowAt: PreviouslySelectedIndex!).accessoryType = .checkmark
//        }
//        else{
//
//        }
        
        super.viewDidLoad()
        
        UIProjectView.layer.cornerRadius = 20
        UIProjectView.layer.shadowColor = UIColor.darkGray.cgColor
        UIProjectView.layer.shadowRadius = 50
        UIProjectView.layer.shadowOpacity = 0.20
        tableView.delegate = self
        tableView.dataSource = self
        
        Projects = Project.loadProjects()
    }
    
    var ProjectSelected: Project?
    
//
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if ProjectSelected != nil{
//            return PreviouslySelectedIndex
//        }
//        else {
//            return nil
//        }\
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if PreviouslySelectedIndex != nil{
            if indexPath == PreviouslySelectedIndex{
                ProjectSelected = Projects[indexPath.row]
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryView = nil
                cell?.backgroundColor = UIColor.clear
//                tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
                PreviouslySelectedIndex = nil
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
                let project = Project(ProjectTitle: nil, ProjectColor: nil)
                delegate?.didSelect(ProjectSelected: project)
//                dismiss(animated: true, completion: nil)
            
            }
            else{
                ProjectSelected = Projects[indexPath.row]
                delegate?.didSelect(ProjectSelected: ProjectSelected!)
                dismiss(animated: true, completion: nil)
                PreviouslySelectedIndex = indexPath
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
            }
        }
        else{
            ProjectSelected = Projects[indexPath.row]
            delegate?.didSelect(ProjectSelected: ProjectSelected!)
            dismiss(animated: true, completion: nil)
            PreviouslySelectedIndex = indexPath
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        }
    }

}

// HAVE TO ADD METHOD WHERE IF I CLICK ON SAME PROJECT AGAIN, THE DELEGATE GETS DELETED
