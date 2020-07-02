//
//  HomeViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 26.07.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import Gemini

extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}


let Sections = ["Scheduled", "Inbox", "Habits", "Projects"]
let BackgroundColorTop = ["FF867D","17EAD9","FF7BF0","43E695","B0E5CA", "F5BA41"]
let BackgroundColorBottom = ["D0021B","6078EA","A531C8","3BB2B8","B0E5CA", "F5BA41"]
let SectionImages = [UIImage(named: "Scheduled"), UIImage(named:"Inbox_Home"), UIImage(named: "Habits_Home"), UIImage(named: "Project_Home")]

class HomeViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    

    let aColor = UIColor(named: "CustomBackgroundColor")
    
    
    let feedback = UIImpactFeedbackGenerator()
    
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "eda6b8c0ea2022efb39a859c3239fe39"
    
    @IBOutlet weak var CollectionView: GeminiCollectionView!
    
    @IBOutlet weak var ScheduledView: UIView!
    @IBOutlet weak var InboxView: UIView!
    @IBOutlet weak var HabitView: UIView!
    @IBOutlet weak var ProjectView: UIView!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func configureAnimation() {
        CollectionView.gemini
            .scaleAnimation()
            .scale(0.8)
            .scaleEffect(.scaleUp) // or .scaleDown
    }
    
//    func prepare() {
//        let collectionView = self.CollectionView
//        let itemsCount = collectionView!.numberOfItems(inSection: 0)
//        for item in 0..<itemsCount {
//            let indexPath = IndexPath(item: item, section: 0)
//            cachedItemsAttributes[indexPath] = createAttributesForItem(at: indexPath)
//        }
//    }

//    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//      return cachedItemsAttributes
//        .map { $0.value }
//        .filter { $0.frame.intersects(rect) }
//    }
//
//func findClosestAttributes(toXPosition xPosition: CGFloat) -> UICollectionViewLayoutAttributes? {
//      let collectionView = CollectionView
//      let searchRect = CGRect(
//        x: xPosition - collectionView!.bounds.width, y: collectionView!.bounds.minY,
//        width: collectionView!.bounds.width * 2, height: collectionView!.bounds.height
//      )
//    return searchRect
////      return layoutAttributesForElements(in: searchRect)?.min(by: { abs($0.center.x - xPosition) < abs($1.center.x - xPosition) })
//    }
//
//func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//    let collectionView = CollectionView
//   let midX: CGFloat = collectionView!.bounds.size.width / 2
//   let closestAttribute = findClosestAttributes(toXPosition: proposedContentOffset.x + midX)
//   return CGPoint(x: closestAttribute!.center.x - midX, y: proposedContentOffset.y)
// }
    
    func selectNearestCell() {
//        let indexPath =
//        CollectionView.selectItem(at: indexPath, animated: true)
     
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.CollectionView.scrollToNearestVisibleCollectionViewCell()
        }
//        CollectionView.selectItem(at: IndexPath, animated: true, scrollPosition:)
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.CollectionView.scrollToNearestVisibleCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Sections.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if indexPath.row == 0{
            ScheduledView.alpha = 1.0
            InboxView.alpha = 0.0
            HabitView.alpha = 0.0
            ProjectView.alpha = 0.0
        }
        else if indexPath.row == 1{
            ScheduledView.alpha = 0.0
            InboxView.alpha = 1.0
            HabitView.alpha = 0.0
            ProjectView.alpha = 0.0
        }
        else if indexPath.row == 2{
            ScheduledView.alpha = 0.0
            InboxView.alpha = 0.0
            HabitView.alpha = 1.0
            ProjectView.alpha = 0.0
        }
        else if indexPath.row == 3{
            ScheduledView.alpha = 0.0
            InboxView.alpha = 0.0
            HabitView.alpha = 0.0
            ProjectView.alpha = 1.0
        }
        feedback.impactOccurred()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! HomeSectionCollectionViewCell
        let lightcolor = UIColor(named: "TextColorLight")
        let dimtextcolor = UIColor(named: "TextColorDim")
//        self.CollectionView.animateCell(cell)
        
        if indexPath.row == 1 {
            CoreDataManager.shared.fetchInboxTasks()
            cell.TaskAmountLabel.text = String(inboxTasks.count)
        }
        
        cell.TitleLabel.text = Sections[indexPath.row]
        cell.SectionImage.image = SectionImages[indexPath.row]
        cell.layer.cornerRadius = 28
        cell.layer.backgroundColor = UIColor.backgroundColor.cgColor
//        cell.layer.backgroundColor = UIColor.clear.cgColor// very important for Gradient Layer
        cell.layer.masksToBounds = false
        cell.TitleLabel.textColor = UIColor.textColor
        cell.TaskAmountLabel.textColor = dimtextcolor
        cell.layer.shadowOpacity = 0.20
        cell.layer.shadowRadius = 10
        cell.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.layer.shadowColor = lightcolor!.cgColor
    
        cell.contentView.layer.cornerRadius = 25
        
//        cell.contentView.backgroundColor = UIColor(hexString: BackgroundColorTop[indexPath.row])
//        cell.layer.backgroundColor = UIColor(hexString: BackgroundColor[indexPath.row]).cgColor
        self.CollectionView.animateCell(cell)

        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.CollectionView.animateVisibleCells()
    }
//
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? GeminiCell {
            self.CollectionView.animateCell(cell)
        }
        
//        let colorTop = UIColor(hexString: BackgroundColorTop[indexPath.row]).cgColor
//        let colorBottom = UIColor(hexString: BackgroundColorBottom[indexPath.row]).cgColor
//        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
//        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
// Implementation of Gradient Layer to Cells
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [colorTop, colorBottom]
////        gradientLayer.locations = [0.0, 1.0]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.2)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradientLayer.frame = cell.contentView.bounds
//        gradientLayer.cornerRadius = 25
//        cell.layer.addSublayer(gradientLayer)
//        cell.contentView.layer.insertSublayer(gradientLayer, at: 0)
//        cell.layer.backgroundColor = UIColor.clear.cgColor
//        cell.contentView.layer.addSublayer(gradientLayer)
//    }
    
//    func setGradientBackground() {
//
//
//        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    


    
    //TODO: Declare instance variables here
    
    let locationManager = CLLocationManager()
    
    
    //MARK: - NETWORKING
    //*************************************
    
    func getWeatherData(url: String, parameters: [String: String]){
        
        
//        Alamofire.request(url, method: .get, Parameters: parameters).responseJSON{
//            response in
//            if response.result.isSuccess {
//                print("Success! Got the weather data")
//
//            }
//            else{
//                print("Error \(response.result.erro)")
//                self.cityLabel.text = "Connection Issue"
//            }
//        }
        
        
/// LEAVE BE UNTIL THERE IS DOCUMENATION ON THE CHANGES FOR ALAMO 5
 

    }
    
    
    //MARK: - JSON PARSING
    //*************************************
    
    
    //MARK: Location Manager Delegate Methods
    //*********************************
    
    //Write the didUpdateLocations method:
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1] //grabs most precise last value
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
            
            // FROM OPENWEATHER API DOCUMENATION
        }
    }
    
    //Write didFailWithError method:
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Unavailable"
    }
    
    
    
    @IBOutlet weak var DayOfTheWeekLabel: UILabel!
    @IBOutlet weak var MonthLabel: UILabel!
    
    let cellScale: CGFloat = 0.6

    
    override func viewWillAppear(_ animated: Bool) {
        CollectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 40)
    }
    
    override func viewDidLoad() {
        
        
// YOUTUBE VIDEO
        
//        let screenSize = UIScreen.main.bounds.size
//        let cellWidth = floor(screenSize.width * cellScale)
//        let cellHeight = floor(screenSize.height * cellScale)
//        let insetX = (view.bounds.width - cellWidth) / 2.0
//        let insetY = (view.bounds.height - cellHeight) / 2.0
//        let layout = CollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
//        CollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        HabitView.alpha = 0.0
        InboxView.alpha = 1.0
        configureAnimation()
        CollectionView?.delegate = self
        CollectionView?.dataSource = self
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .BackgroundColor
        } else {
            // Fallback on earlier versions
        } // Change Color of Background based on system preference
        super.viewDidLoad()
        
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE, MMM d"
        MonthLabel.text = dateformatter.string(from: Date())
        
        // Date().dayOfWeek()!
        DayOfTheWeekLabel.text = "Home"
//                DateNumberLabel.text = Date().DateNumber()!
//                MonthLabel.text = Date().month()!
        
        // TODO: Set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters //Potentially change to three kilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
        loadSampleTaskEntities()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
//
//extension ViewController: UIScrollViewDelegate, UICollectionViewDelegate
//{
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let layout = self.CollectionView.collectionViewLayout as! UICollectionViewDelegate
//    }
//
//}

