//
//  UpdateProfile.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-04-23.
//

import UIKit

class UpdateProfileViewController: UIViewController {
    
    let url = URL(string: "https://sundaland.herokuapp.com/api/users/profile")!
    
    var token : String = ""
    var isOwner : Bool = false
    
    
    @IBOutlet var tfAddress: UITextField!
    @IBOutlet var tfCity: UITextField!
    @IBOutlet var tfPostalCode: UITextField!
    @IBOutlet var tfCountry: UITextField!
    var newUser = User()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Update Profile"
        
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func updateProfile(){
        
        if (!self.tfAddress.text!.isEmpty && !self.tfCity.text!.isEmpty && !self.tfPostalCode.text!.isEmpty && !self.tfCountry.text!.isEmpty) {
            
            
            newUser.userAddress.address = self.tfAddress.text!
            newUser.userAddress.city = self.tfCity.text!
            newUser.userAddress.postalCode = self.tfPostalCode.text!
            newUser.userAddress.country = self.tfCountry.text!
            
            
            //fetch to database
            submitToDatabase()
            
            self.askConfirmation()
            
        }else{
            self.showErrorAlert(errorMessage: "None of the inputs can be empty")
        }
    }
    
    
    func showErrorAlert(errorMessage : String){
        let errorAlert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func askConfirmation(){
        let confirmAlert = UIAlertController(title: "Confirmation", message: "Please verify your information to update the profile.", preferredStyle: .actionSheet)
        
        confirmAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in self.goToProfilePage()
            
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    
    
    
    func submitToDatabase() {
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        let parameters = [ "userAddress" : ["address" : newUser.userAddress.address, "city" : newUser.userAddress.city, "postalCode" : newUser.userAddress.postalCode, "country" : newUser.userAddress.country]] as Dictionary<String, AnyObject>
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" //set http method as POST
        
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
                    // handle json...\
                    
                    if let obj = json as? NSDictionary {
                        
                        if ((obj["token"]) != nil){
                            
                            self.token = obj["token"] as! String
                            print(self.token)
                            
                        }else{
                            print("eroor!")
                        }
                        
                    }
                }
                
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    func goToProfilePage(){
        
        if(!isOwner){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileVC = storyboard.instantiateViewController(identifier: "ProfileVC") as! UserProfileViewController
        profileVC.token = token
        self.navigationController?.pushViewController(profileVC, animated: true)
        
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let profileVC = storyboard.instantiateViewController(identifier: "OwnerProfileVC") as! OwnerProfileViewController
            profileVC.token = token
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
        
    }
    
    
}
