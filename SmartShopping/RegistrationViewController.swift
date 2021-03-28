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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func createAccount(){
        
        if (!self.tfEmail.text!.isEmpty && !self.tfName.text!.isEmpty && !self.tfPassword.text!.isEmpty && !self.tfConfirmPassword.text!.isEmpty) {
            
            if (self.tfPassword.text == self.tfConfirmPassword.text){
                
                if(isValidName(tfName.text!)){
                    
                    if(isValidEmail(tfEmail.text!)){
                        
                        if(isValidPassword(password: tfPassword.text!)){
                            
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
                        }else{
                            self.showErrorAlert(errorMessage: "Password sholud be at least 6 digits")
                        }
                    }else{
                        self.showErrorAlert(errorMessage: "Please enter the valid email")
                    }
                }
                else{
                    self.showErrorAlert(errorMessage: "Please enter the valid name")
                }
            }
            else{
                self.showErrorAlert(errorMessage: "Both passwords must be same")
            }
        }
        else{
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
    
    func isValidName(_ name: String) -> Bool {
        let nameRegEx = "^[a-zA-Z-,]+(\\s{0,1}[a-zA-Z-, ])*$"
        
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        //  let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailRegEx = "\\S+@\\S+.\\S+"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let passRegEx = ".{6,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    
}




