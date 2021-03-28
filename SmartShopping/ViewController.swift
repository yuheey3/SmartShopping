//
//  ViewController.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-03-27.
//
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfPassword : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Log in"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func logIn(){
        if (tfEmail.text != nil && tfPassword.text != nil){
            let email = self.tfEmail.text
            let password = self.tfPassword.text
            
            //find email and password from database
            if(email == "yuheey3@yahoo.co.jp" && password == "c123123"){
                //login successful
                print("login successful")
                
            }else{
                //login unsuccessful
                let alert = UIAlertController(title: "Login unsuccessful", message: "Incorrect email and/or password. Try again!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}

