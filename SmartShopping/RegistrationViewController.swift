//
//  RegestratonViewController.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-03-28.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    let url = URL(string: "https://sundaland.herokuapp.com/api/users")!
    
    
    
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
                            
                            //fetch to database
                            submitToDatabase()
                            
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
    
    
    func submitToDatabase() {
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        let parameters = ["name": newUser.name, "password": newUser.password, "email" : newUser.email] as Dictionary<String, String>
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
        
    }
    
}
