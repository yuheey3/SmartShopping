//
//  RegestratonViewController.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-03-28.
//

import UIKit

class RegistrationViewController: UIViewController {


    
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var tfConfirmPassword: UITextField!
    @IBOutlet var segIsOwner : UISegmentedControl!
    var newUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Registration"
       
        
    
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func createAccount(){
        
        if (!self.tfEmail.text!.isEmpty && !self.tfName.text!.isEmpty && !self.tfPassword.text!.isEmpty && !self.tfConfirmPassword.text!.isEmpty) {
            
            if (self.tfPassword.text == self.tfConfirmPassword.text){
                
                newUser.name = self.tfName.text!
                newUser.email = self.tfEmail.text!
                newUser.password = self.tfPassword.text!
                
                var check: String
                check = self.segIsOwner.titleForSegment(at: self.segIsOwner.selectedSegmentIndex)!
                
                if(check == "Owner"){
                    newUser.isOwner = true
                }
                else{
                    newUser.isOwner = false
                }
              
                
                print(#function, "Name : \(newUser.name) Email : \(newUser.email) Password : \(newUser.password) isOwner : \(newUser.isOwner)")
                
                self.askConfirmation()
            }
            else{
                //show error
                self.showErrorAlert(errorMessage: "Both passwords must be same")
            }
        }
        else{
            //show error
            self.showErrorAlert(errorMessage: "None of the inputs can be empty")
        }
    }
    
    func showErrorAlert(errorMessage : String){
        let errorAlert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func askConfirmation(){
        let confirmAlert = UIAlertController(title: "Confirmation", message: "Please verify your information to create account.", preferredStyle: .actionSheet)
        
        confirmAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in //_ in
           // self.goToShoppingScreen()
            
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(confirmAlert, animated: true, completion: nil)
    }


}



