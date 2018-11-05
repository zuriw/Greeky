//
//  FinanceTableViewController.swift
//  VTaKDPhi
//
//  Created by Zuri Wong on 11/2/18.
//  Copyright © 2018 Zuri Wong. All rights reserved.
//

import UIKit
import Firebase

struct DueStruct {
    let id: String!
    let name : String!
    let cost : Float!
    let dueDate : String!
    let late : Bool!
    let description : String!
    let people: [String]!
    let all: Bool!
}


class FinanceTableViewController: UITableViewController{
    
    @IBOutlet var financeTableView: UITableView!
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var ref: DatabaseReference!
    var dues = [DueStruct]()
    
    let tableViewRowHeight: CGFloat = 94.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //post()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.getDuesFromDb()
    }
    
    @IBAction func unwindToFinanceTableViewController (segue : UIStoryboardSegue) {
        if segue.identifier == "Add Dues"{
            let addDuesViewController: addDuesViewController = segue.source as! addDuesViewController
            if addDuesViewController.amountTextField.text == "" || addDuesViewController.descriptionTextView.text == ""{
                createAlart(title: "Error Occurred", message: "Please entered all information")
                return
            }
            
            var name = addDuesViewController.categoryPickerData[addDuesViewController.categoryPickerView.selectedRow(inComponent: 0)]
            if name == "Other"{
                if addDuesViewController.otherCategoryTextField.text == ""{
                    createAlart(title: "Error Occurred", message: "Please enter a category")
                    return
                }
                name = addDuesViewController.otherCategoryTextField.text!
            }
            
            let description = addDuesViewController.descriptionTextView.text!
            if let amount = Float(addDuesViewController.amountTextField.text!){
                print("amount converted to Float")
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "yyyy-MM-dd"
                
                let dueDate = formatter.string(from: addDuesViewController.dueDateDatePicker.date)
                
                var people = [String]()
                people.append(addDuesViewController.peoplePickerData[addDuesViewController.peoplePickerView.selectedRow(inComponent: 0)])
                var all = false
                if people.first == "All"{
                    all = true
                }
                
                post(name: name, amount: amount, dueDate: dueDate, description: description, people: people)
            }else{
                createAlart(title: "Error Occurred", message: "Please enter valid number for amount")
                return
            }
        }
        
    }
        
        
    
    
    
    func post(name: String, amount: Float, dueDate: String, description: String, people: [String]){
        var all = true
        if people.count > 0{
            all = false
        }
        ref = Database.database().reference()
        
        let due : [String: AnyObject] = ["name" : name as AnyObject,
                                         "cost" : amount as AnyObject,
                                         "dueDate" : dueDate as AnyObject,
                                         "late" : false as AnyObject,
                                         "description" : description as AnyObject,
                                         "people": people as AnyObject,
                                         "all": all as AnyObject]
        ref.child("Dues").childByAutoId().setValue(due){
            (error: Error?, ref: DatabaseReference) in
            if let error = error {
                print("data cannot be saved")
            }else{
                self.getDuesFromDb()
                self.financeTableView.reloadData()
            }
        }
    }
    
    func getDuesFromDb(){
        ref = Database.database().reference()
        //dues = applicationDelegate.dues
        dues.removeAll()
        ref.child("Dues").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            for item in snapshot.children{
                
                if let due = (item as! DataSnapshot).value as? [String:AnyObject]{
                    let id = (item as! DataSnapshot).key
                    let name = due["name"] as! String
                    let cost = due["cost"] as! Float
                    let dueDate = due["dueDate"] as! String
                    let late = due["late"] as! Bool
                    let description = due["description"] as! String
                    let people = due["people"] as! [String]
                    let all = due["all"] as! Bool
                    
                    ///only show dues that are yours / all
                    
                    //if people.contains("All") || people.contains()
                    self.dues.insert(DueStruct(id: id, name: name, cost: cost, dueDate: dueDate, late: late, description: description, people: people, all: all), at: 0)
                    
                }
            }
            self.financeTableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dues.count
    }
    
    // Asks the table view delegate to return the height of a given row.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowNumber = (indexPath as NSIndexPath).row
        let cell: FinanceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FinanceTableViewCell
        cell.nameLabel.text = dues[rowNumber].name
        cell.costLabel.text = "\(dues[rowNumber].cost!)"
        switch dues[rowNumber].late {
        case true:
            cell.lateSegmentControl.selectedSegmentIndex = 1
        default:
            cell.lateSegmentControl.selectedSegmentIndex = 0
        }
        cell.dueDateLabel.text = dues[rowNumber].dueDate
        print(dues[rowNumber])
        return cell
    }
    
    //Allow Edit
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //delete button tapped
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let row = (indexPath as NSIndexPath).row
            let dueId = dues[row].id
            ref.child("Dues").child(dueId!).removeValue(completionBlock: { (error, refer) in
                if error != nil {
                    
                } else {
                    //print(refer)
                    self.dues.remove(at: row)
                    print("Child Removed Correctly")
                    self.financeTableView.reloadData()
                }
            })
            
        }
    }
    
    func createAlart(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
