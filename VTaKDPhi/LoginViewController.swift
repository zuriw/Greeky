//
//  LoginViewController.swift
//  VTaKDPhi
//
//  Created by Zuri Wong on 11/2/18.
//  Copyright © 2018 Zuri Wong. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    var ref: DatabaseReference!
    var authUsers = [String: String]()
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let emailAddr = usernameTextField.text!
        let password = passwordTextField.text!
        
        if emailAddr == "" || password == ""{
            self.createAlart(title: "Error Occurred", message: "Please enter your username / password.")
            return
        }
        
        //Check if user is authorized
        ref.child("AuthUsers").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            for user in snapshot.children{
                let uid = (user as! DataSnapshot).key as! String
                let email = (user as! DataSnapshot).value as! String
                self.authUsers[uid] = email
            }
            
            //user is authorized to signin / signup
            if self.authUsers.values.contains(emailAddr){
                Auth.auth().createUser(withEmail: emailAddr, password: password) { (authResult, error) in
                    
                    if error == nil{
                        self.applicationDelegate.username = email
                        self.createAlart(title: "Account Created", message: "Your account has been created! Welcome to Greeky!")
                        self.performSegue(withIdentifier: "Create Account", sender: self)
                    }else{
                        //if error, could be that user is already created
                        self.login(email: emailAddr, password: password)
                    }
                    
                }
            }else{
                self.createAlart(title: "Error Occurred", message: "Sorry, you do not have the authorization to create account, please get permissino from administrator.")
            }
        })
        
       
        
    }
    
    
    func login(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            //error occured
            if error != nil{
                self.createAlart(title: "Error Occurred", message: "Sorry, we are unabled to find your account, please try again.")
            }else{
                self.applicationDelegate.username = email
                self.performSegue(withIdentifier: "Show Dashboard", sender: self)
                print("login success")
            }
        }
    }
    
    func createAlart(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {

    }
    
    @IBAction func keyboardDone(_ sender: UITextField){
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTouch(_ sender: UIControl){
        view.endEditing(true)
    }
    
}
