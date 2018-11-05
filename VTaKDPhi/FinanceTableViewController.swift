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
        ref = Database.database().reference()
        //dues = applicationDelegate.dues
        ref.child("Dues").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            for item in snapshot.children{
                
                if let due = (item as! DataSnapshot).value as? [String:AnyObject]{
                    let id = (item as! DataSnapshot).key
                    let name = due["name"] as! String
                    let cost = due["cost"] as! Float
                    let dueDate = due["dueDate"] as! String
                    let late = due["late"] as! Bool
                    let description = due["description"] as! String
                    self.dues.insert(DueStruct(id: id, name: name, cost: cost, dueDate: dueDate, late: late, description: description), at: 0)
                    
                    }
                }
            self.financeTableView.reloadData()
        })
    }
    
    func post(){
        let name = "Nat Board Dues"
        let cost = 40.00
        let dueDate = "10-20-2018"
        let late = true
        let description = "Payment plan can be created based on your needs"
        ref = Database.database().reference()
        
        let due : [String: AnyObject] = ["name" : name as AnyObject,
                                         "cost" : cost as AnyObject,
                                         "dueDate" : dueDate as AnyObject,
                                         "late" : late as AnyObject,
                                         "description" : description as AnyObject]
        ref.child("Dues").childByAutoId().setValue(due)
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
    
}
