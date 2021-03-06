//
//  CreateAccountViewController.swift
//  VTaKDPhi
//
//  Created by Zuri Wong on 11/4/18.
//  Copyright © 2018 Zuri Wong. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var choosePictureButton: UIButton!
    var imagePicker = UIImagePickerController()
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var email: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        choosePictureButton.imageView?.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
    }
    
    @IBAction func chooseProfilePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = pickedImage
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let nickName = nicknameTextField.text!
        let birthday = datePicker.date
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"
        
        let birthdayString = formatter.string(from: birthday)
        
        // Create a reference to the file you want to upload
        print(firstName)
        let imageRef = storageRef.child("images/\(firstName).png")
        
        if firstName == "" || lastName == "" || nickName == ""{
            createAlart(title: "Error Occurred", message: "Missing information, please enter all required fields.")
            return
        }
        
        let user : [String: AnyObject] = ["firstName" : firstName as AnyObject,
                                         "lastName" : lastName as AnyObject,
                                         "nickName" : nickName as AnyObject,
                                         "birthday" : birthdayString as AnyObject]
        
        if let profileImageData = UIImagePNGRepresentation(imageView.image!){
//            imageRef.putData(profileImageData)
            imageRef.putData(profileImageData, metadata: nil, completion: {
                (metadata, error) in
                if error != nil{
                    print("something went wrong")
                    self.createAlart(title: "Error Occurred", message: "Cannot upload image!")
                    return
                }
                print("upload success")
                print(self.applicationDelegate.username)
                self.ref.child("Users").child(self.applicationDelegate.username).setValue(user)
                self.login(email: self.email, password: self.password, username: self.applicationDelegate.username)
                
            })
        }
       
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func createAlart(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func login(email: String, password: String, username: String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            //error occured
            if error != nil{
                self.createAlart(title: "Error Occurred", message: "Sorry, we are unabled to find your account, please try again.")
            }else{
                self.applicationDelegate.username = username
                self.performSegue(withIdentifier: "Show Dashboard", sender: self)
                print("login success")
            }
        }
    }
}
