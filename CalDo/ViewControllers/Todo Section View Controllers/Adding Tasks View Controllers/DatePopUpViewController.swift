//
//  DatePickerViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 30.07.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit
import JTAppleCalendar
//import HMSegmentedControl.h
//import DateTimePicker


protocol SendDateAndTimeback {
    
    func DateAndTimeReceived(data: DateAndTime)
    
}

class DatePopUpViewController: UIViewController, SendTimeBackDelegate {
    
     var delegate: SendDateAndTimeback?
    
    let impact = UIImpactFeedbackGenerator()
    
    let addimage = UIImage(named: "Add_Symbol")
    let editimage = UIImage(named: "Edit_Symbol")
    
    var timePreviouslySelected: String?
    var datePreviouslySelected: String?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TimePickerSegue" {
            let secondVC = segue.destination as! TimePickerViewController
            
            secondVC.timePreviouslyPicked = AddTimeButton.currentTitle!
            secondVC.delegate = self
        }
    }
//
//        if TimeLabel.text != ""
//            AddTimeButton.setTitle("Edit Time", for: .normal)
    

    @IBAction func TodayButtonPressed(_ sender: Any) {
        calendarView.selectDates([Date()])
        calendarView.scrollToDate(Date())
        calendarView.reloadData()
    }
    
    @IBAction func TomorrowButtonPressed(_ sender: Any) {
        func tomorrow() -> Date {
            
            var dateComponents = DateComponents()
            dateComponents.setValue(1, for: .day); // +1 day
            
            let now = Date() // Current date
            let tomorrow = Calendar.current.date(byAdding: dateComponents, to: now)  // Add the DateComponents
            
            return tomorrow!
        }
        calendarView.selectDates([tomorrow()])
        calendarView.scrollToDate(Date())
        calendarView.reloadData()
    
    }
    

    @IBAction func RemoveTimePressed(_ sender: Any) {
        AddTimeButton.setTitle("Add Time", for: .normal)
        PopUpView.sendSubviewToBack(RemoveTimeButton)
        timePreviouslySelected = nil
        AddTimeButton.setImage(addimage, for: .normal)
        impact.impactOccurred()
    }
    

    @IBOutlet weak var Test: UILabel!
    
    @IBOutlet weak var RemoveTimeButton: UIButton!
    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var AddTimeButton: UIButton!
    
    func dataReceived(data: String) {
        AddTimeButton.setTitle(data, for: .normal)
        PopUpView.bringSubviewToFront(RemoveTimeButton)
        AddTimeButton.setImage(editimage, for: .normal)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    

    
//    func hexStringToUIColor (hex:String) -> UIColor {
//        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//
//        if (cString.hasPrefix("#")) {
//            cString.remove(at: cString.startIndex)
//        }
//
//        if ((cString.count) != 6) {
//            return UIColor.gray
//        }
//
//        var rgbValue:UInt64 = 0
//        Scanner(string: cString).scanHexInt64(&rgbValue)
//
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }
    
//    @IBAction func AddTimeButtonPressed(_ sender: Any) {
//        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
//        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
//        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
//
//        // customize your picker
//        //        picker.timeInterval = DateTimePicker.MinuteInterval.thirty
//        //        picker.locale = Locale(identifier: "en_GB")
//        //
//                picker.todayButtonTitle = ""
//                picker.is12HourFormat = true
//                picker.dateFormat = "hh:mm aa"
//                picker.isTimePickerOnly = true
//        picker.includeMonth = true // if true the month shows at bottom of date cell
//        picker.highlightColor = UIColor.blue
//        picker.darkColor = UIColor.darkGray
//        picker.doneButtonTitle = "Done"
//        picker.doneBackgroundColor = UIColor.blue
//        picker.completionHandler = { date in
//            let formatter = DateFormatter()
//            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
//            self.title = formatter.string(from: date)
//        }
//        picker.delegate = self
//
//        // add picker to your view
//        // don't try to make customize width and height of the picker,
//  //       you'll end up with corrupted looking UI
//                picker.frame = CGRect(x: 0, y: 100, width: picker.frame.size.width, height: picker.frame.size.height)
//        // set a dismissHandler if necessary
//        //        picker.dismissHandler = {
//        //            picker.removeFromSuperview()
//        //        }
//        //        self.view.addSubview(picker)
//
//        // or show it like a modal
//        picker.show()
//    }
    
//    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
//        title = picker.selectedDateString
//    }
    
//    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"One", @"Two", @"Three"]];
//    segmentedControl.frame = CGRectMake(10, 10, 300, 60);
//    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:segmentedControl];
    
    

    @IBAction func SaveButtonPressed(_ sender: Any) {
        let timeselected = AddTimeButton.titleLabel?.text
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy "
        let dateselected = dateformatter.string(from: calendarView.selectedDates[0])
        let SelectedDateAndTime = DateAndTime(date: dateselected, time: timeselected)
        delegate?.DateAndTimeReceived(data: SelectedDateAndTime)
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        
        AddTimeButton.imageView?.contentMode = .scaleAspectFit
        AddTimeButton.imageEdgeInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        
        if timePreviouslySelected != nil{
            AddTimeButton.setTitle(timePreviouslySelected, for: .normal)
            PopUpView.bringSubviewToFront(RemoveTimeButton)
            AddTimeButton.setImage(editimage, for: .normal)
//            let date: Date = formatter.date(from: datePreviouslySelected!)!
 //           calendarView.selectDates(from: date, to: date)
//            Calendar doesnt work yet
        }
        else {
            AddTimeButton.setTitle("Add Time", for: .normal)
            PopUpView.sendSubviewToBack(RemoveTimeButton)
            AddTimeButton.setImage(addimage, for: .normal)
            
        }
    
        
        PopUpView.layer.cornerRadius = 30
        PopUpView.layer.shadowColor = UIColor.black.cgColor
        PopUpView.layer.shadowRadius = 50
        PopUpView.layer.shadowOpacity = 0.20
        SaveButton.layer.cornerRadius = 10
//        SaveButton.layer.backgroundColor = UIColor(hexString: "#4FC2E8").cgColor
        AddTimeButton.layer.cornerRadius = 10
        AddTimeButton.layer.backgroundColor = UIColor(hexString: "#F6F7F9").cgColor
        super.viewDidLoad()
        
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode   = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = true
        calendarView.showsVerticalScrollIndicator = false
        calendarView.layer.cornerRadius = 10
//        calendarView.scrollToDate(Date())
        calendarView.selectDates(from: Date(), to: Date())
        
//        PopUpView.insertSubview(PopUpView, belowSubview: RemoveTimeButton)
    
//
        
        
    }
}




extension DatePopUpViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
    
        let startDate = Date()
        let endDate = formatter.date(from: "2026 01 01")!
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension DatePopUpViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        cell.selectedView.layer.backgroundColor = UIColor(hexString: "#4FC2E8").cgColor
        
        return cell
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        let formatter2 = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter2.dateFormat = "YYYY"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
//        header.yearTitle.text = formatter2.string(from: range.start)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
}

func configureCell(view: JTAppleCell?, cellState: CellState) {
    guard let cell = view as? DateCell  else { return }
    cell.dateLabel.text = cellState.text
    handleCellTextColor(cell: cell, cellState: cellState)
    handleCellSelected(cell: cell, cellState: cellState)
}

func handleCellSelected(cell: DateCell, cellState: CellState) {
    
    if cellState.isSelected {
        cell.selectedView.layer.cornerRadius =  13
        cell.selectedView.isHidden = false
        cell.dateLabel.textColor = UIColor.white
        cell.dateLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
    } else {
        cell.selectedView.isHidden = true
        cell.dateLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
//        cell.dateLabel.textColor = UIColor(hexString: "606873")
    }

}




func handleCellTextColor(cell: DateCell, cellState: CellState) {
    if cellState.dateBelongsTo == .thisMonth {
        cell.dateLabel.textColor = UIColor.black
    } else {
        cell.dateLabel.textColor = UIColor.gray
    }
}
