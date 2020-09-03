//
//  TodayViewController.swift
//  
//
//  Created by Fabian Jaeger on 15.09.19.
//

import UIKit

class TodayViewController: TaskTableViewController {
    

    override func viewDidLoad() {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        var dateTo = calendar.startOfDay(for: Date())
        dateTo = calendar.date(byAdding: .day, value: 1, to: dateTo)!
        
        predicate = NSPredicate(format: "(completed == false) AND (date <= %@)", dateTo as NSDate)
        
        titleLabel.text = "Today"
        
        let imageView = UIImageView(image: UIImage(named: "Today_Todo"))
        imageView.frame = titleIcon.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleIcon.addSubview(imageView)
        
        super.viewDidLoad()
        
    }
}

//extension TodayViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = todayTableView.searchController.searchBar
//        todayTableView.filterTasksForSearchText(searchBar.text!)
//    }
//}

//
//    func clearNavigationBar(forBar navBar: UINavigationBar) {
//        navBar.setBackgroundImage(UIImage(), for: .default)
//        navBar.shadowImage = UIImage()
//        navBar.isTranslucent = true
//    }
//    
//    
//    
//    @IBAction func BackButtonPressed(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    override func viewDidLoad() {
//        
//        
////        navigationController!.navigationBar.barTintColor = UIColor(hexString: "4FC2E8")
//        
//        if let navController = navigationController {
//            clearNavigationBar(forBar: navController.navigationBar)
//            navController.view.backgroundColor = .clear
//        }
//    
//        super.viewDidLoad()
////
////        self.navigationItem.titleView = navTitleWithImageAndText(titleText: "Today", imageName: "Today")
//        self.navigationController!.navigationBar.titleTextAttributes =
//            [NSAttributedString.Key.foregroundColor: UIColor(hexString: "4FC2E8"),
//             NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 21)!]
// 
//    }
//    func navTitleWithImageAndText(titleText: String, imageName: String) -> UIView {
//        
//        // Creates a new UIView
//        let titleView = UIView()
//        
//        // Creates a new text label
//        let label = UILabel()
//        label.text = titleText
//        label.font = UIFont(name: "HelveticaNeue-Bold", size: 21)!
//        label.textColor = UIColor(hexString: "3E464F")
//        label.sizeToFit()
//        label.center = titleView.center
//        label.textAlignment = NSTextAlignment.center
//        
//        // Creates the image view
//        let image = UIImageView()
//        image.image = UIImage(named: imageName)
//        
//        // Maintains the image's aspect ratio:
//        let imageAspect = image.image!.size.width / image.image!.size.height
//        
//        // Sets the image frame so that it's immediately before the text:
//        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect - 5
//        let imageY = label.frame.origin.y - 2
//        
//        let imageWidth = label.frame.size.height * imageAspect
//        let imageHeight = label.frame.size.height
//        
//        image.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
//        
//        image.contentMode = UIView.ContentMode.scaleAspectFit
//        
//        // Adds both the label and image view to the titleView
//        titleView.addSubview(label)
//        titleView.addSubview(image)
//        
//        // Sets the titleView frame to fit within the UINavigation Title
//        titleView.sizeToFit()
//        
//        return titleView
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

