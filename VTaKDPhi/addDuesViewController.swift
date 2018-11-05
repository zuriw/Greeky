//
//  addDuesViewController.swift
//  VTaKDPhi
//
//  Created by Zuri Wong on 11/5/18.
//  Copyright © 2018 Zuri Wong. All rights reserved.
//

import UIKit
import Firebase

class addDuesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var ref: DatabaseReference!
    
    @IBOutlet var categoryPickerView: UIPickerView!
    @IBOutlet var otherCategoryTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var dueDateDatePicker: UIDatePicker!
    @IBOutlet var peoplePickerView: UIPickerView!
    
    // Arrays holding constant Picker View data
    let categoryPickerData = ["Chapter Dues", "Nat Board Dues", "fines", "Other"]
    var peoplePickerData = ["All"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        //Get all users
        ref.child("Users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            for user in snapshot.children{
                
                if let userData = (user as! DataSnapshot).value as? [String:AnyObject]{
                    let uid = (user as! DataSnapshot).key
                    let firstName = userData["firstName"] as! String
                    let lastName = userData["lastName"] as! String
                    self.peoplePickerData.append(firstName + " " + lastName)
                    
                }
            }
            
            self.peoplePickerView.reloadAllComponents()
        })
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickerView.tag == 0 ? categoryPickerData[row] : peoplePickerData[row]
        return pickerView.tag == 0 ? categoryPickerData.count : peoplePickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 0 ? categoryPickerData[row] : peoplePickerData[row]
        
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
