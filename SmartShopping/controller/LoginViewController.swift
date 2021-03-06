//
//  ViewController.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-03-27.
//
//
import UIKit

class LoginViewController: UIViewController {
    
    let url = URL(string: "https://sundaland.herokuapp.com/api/users/login")!
    
    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfPassword : UITextField!
    var email : String = ""
    var password : String = ""
    var isFoundUser : Bool = true
    var isOwner : Bool = false
    var name = ""
    
    var token : String = ""
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Log in"
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func logIn(){
        if (tfEmail.text != "" && tfPassword.text != ""){
            
            email = self.tfEmail.text!
            password = self.tfPassword.text!
            
            //find email and password from database
            submitToDatabase()
            
            
            do {
                sleep(5)
            }
            
            if(token != ""){
                //login successful
                print("login successful")
                goToAllStoresViewPage()
                self.tfEmail.text = ""
                self.tfPassword.text = ""
                
            } else{
                //login unsuccessful
                let alert = UIAlertController(title: "Login unsuccessful", message: "Incorrect email and/or password. Try again!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            //login unsuccessful
            let alert = UIAlertController(title: "Login unsuccessful", message: "Please enter the email and password", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
//    //not use anymore
//    func goToProfilePage(){
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        if(!isOwner){
//            let profileVC = storyboard.instantiateViewController(identifier: "ProfileVC") as! UserProfileViewController
//            profileVC.token = token
//            self.navigationController?.pushViewController(profileVC, animated: true)
//            
//        }else{
//            let ownerProfileVC = storyboard.instantiateViewController(identifier: "OwnerProfileVC") as! OwnerProfileViewController
//            ownerProfileVC.token = token
//            self.navigationController?.pushViewController(ownerProfileVC, animated: true)
//            
//        }
//        
//    }
    
    func goToAllStoresViewPage(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if(!isOwner){
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let userMainVC = storyboard.instantiateViewController(identifier: "UserMainVC") as! UserMainViewController
            
            userMainVC.token = token
            userMainVC.userName = name
            self.navigationController?.pushViewController(userMainVC, animated: true)
            
        }else{
//            let ownerProfileVC = storyboard.instantiateViewController(identifier: "OwnerProfileVC") as! OwnerProfileViewController
//            ownerProfileVC.token = token
//            self.navigationController?.pushViewController(ownerProfileVC, animated: true)
            
            
            let ownerMainVC = storyboard.instantiateViewController(identifier: "OwnerMainVC") as! OwnerMainViewController
            ownerMainVC.token = token
            ownerMainVC.name = name
            self.navigationController?.pushViewController(ownerMainVC, animated: true)
            
        }
        
    }
    
    func submitToDatabase() {
        
        self.isFoundUser = true
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        let parameters = ["email": email, "password": password] as Dictionary<String, String>
        
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
                    
                    
                    if let obj = json as? NSDictionary {
                        
                        self.isOwner = obj["isOwner"] as! Bool
                        self.name = obj["name"] as! String
                        
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
                // self.isFoundUser = false
            }
        })
        task.resume()
        
    }
    
}

