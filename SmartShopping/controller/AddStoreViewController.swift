//
//  AddStoreViewController.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-05-14.
//

import UIKit

class AddStoreViewController: UIViewController {
    
    let url = URL(string: "https://sundaland.herokuapp.com/api/stores")!
    
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfCity: UITextField!
    @IBOutlet var tfCountry : UITextField!
    @IBOutlet var tfPostalCode : UITextField!
    @IBOutlet var tfProvince : UITextField!
    @IBOutlet var tfAddress : UITextField!
    var token : String = ""
    
    var name : String = ""
    var city : String = ""
    var country : String = ""
    var postalCode : String = ""
    var province : String = ""
    var address : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Store"
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addStore(){
        
        if (!self.tfName.text!.isEmpty && !self.tfCity.text!.isEmpty && !self.tfCountry.text!.isEmpty && !self.tfPostalCode.text!.isEmpty && !self.tfProvince.text!.isEmpty && !self.tfAddress.text!.isEmpty) {
            
            name = self.tfName.text!
            city = self.tfCity.text!
            country = self.tfCountry.text!
            postalCode = self.tfPostalCode.text!
            province = self.tfProvince.text!
            address = self.tfAddress.text!
            
            //fetch to database
           // submitToDatabase()
            
            self.askConfirmation()
           // self.goToProfilePage()
            
            
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
        let confirmAlert = UIAlertController(title: "Confirmation", message: "Please verify your information to add store.", preferredStyle: .actionSheet)
        
        confirmAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in self.submitToDatabase()
            
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(confirmAlert, animated: true, completion: nil)
    }
    
//    func goToProfilePage(){
//
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            let ownerProfileVC = storyboard.instantiateViewController(identifier: "OwnerProfileVC") as! OwnerProfileViewController
//            ownerProfileVC.token = token
//            self.navigationController?.pushViewController(ownerProfileVC, animated: true)
//        }
        
    
    
    func submitToDatabase() {

        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid

        let parameters = ["name": name, "city" : city, "country": country, "postalCode": postalCode, "province" : province, "streetAddress" : address ] as Dictionary<String, AnyObject>

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
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
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
       // goToProfilePage()

    }
    
        

}
