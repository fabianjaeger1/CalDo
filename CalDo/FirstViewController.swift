//
//  FirstViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 09.10.17.
//  Copyright © 2017 CalDo. All rights reserved.
//

import UIKit

var list = ["Buy Milk", "Run 5 Miles", "Plan trip to Thailand",]


class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var deleteThisPlease = String();
    
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var myIndex = 0
    
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (list.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithIcon", for: indexPath) as! TableCellWithIcon
        let itemname = list[indexPath.row]
        // should add date list and update cell infoview
        cell.labelview?.text = itemname
        cell.infoview?.text = "Date"
        cell.imageview?.image = UIImage(named: "TodoButton")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            list.remove(at: indexPath.row)
            myTableView.reloadData()
        }
    } // This is for deleteing with a left swipe
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        deleteThisPlease = list[myIndex]
        performSegue(withIdentifier: "segue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue"{
            if let dest = segue.destination as? TodoOpened {
                dest.todoName = deleteThisPlease
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myTableView.register(TableCellWithIcon.self, forCellReuseIdentifier: "CellWithText")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

