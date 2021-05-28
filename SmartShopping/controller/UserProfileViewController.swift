//
//  ProfileViewController.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-04-16.
//

import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet var tfName: UILabel!
    @IBOutlet var tfEmail: UILabel!
    @IBOutlet var tfAddress : UILabel!
    @IBOutlet var tfCity: UILabel!
    @IBOutlet var tfpostalCode: UILabel!
    @IBOutlet var tfCountry : UILabel!
    @IBOutlet var tfIsOwner : UILabel!
    var token : String = ""
    var name : String = ""
    var email : String = ""
    var address : String = ""
    var city : String = ""
    var postalCode : String = ""
    var country : String = ""
    var isOwner : Bool = false
    
    
    
    
    
    let url = URL(string: "https://sundaland.herokuapp.com/api/users/profile")!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Profile"
        
        
        submitToDatabase()
        
    }
    
    func submitToDatabase() {
        
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        // let parameters = ["token": token] as Dictionary<String, String>
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "GET" //set http method as POST
        
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
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] , let userAddress = json["userAddress"] as? [String : Any]
                {
                    print(json)
                    
                    if let obj = json as? NSDictionary {
                        
                        
                        self.name = obj["name"] as! String
                        self.email = obj["email"] as! String
                        self.isOwner = obj["isOwner"] as! Bool
                        
                        if let obj2 = userAddress as? NSDictionary{
                            
                            self.address = obj2["address"] as! String
                            self.city = obj2["city"] as! String
                            self.postalCode = obj2["postalCode"] as! String
                            self.country = obj2["country"] as! String
                            
                            DispatchQueue.main.async {
                                var tmp : String = ""
                                if(self.isOwner){
                                    tmp = " Owner"
                                  
                                }
                                else{
                                    tmp = " Customer"
                                }
                                print(tmp)
                                self.tfName.text = "Hi " + self.name + tmp + " !"
                                self.tfEmail.text = self.email
                                self.tfAddress.text = self.address
                                self.tfCity.text = self.city
                                self.tfpostalCode.text = self.postalCode
                                self.tfCountry.text = self.country
                                
                              
                                
                            }
                        }
                    }
                }
                
                
                
            }catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    
    @IBAction func goToUpdateProfile(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let updateProfileVC = storyboard.instantiateViewController(identifier: "UpdateProfileVC") as! UpdateProfileViewController
        
        updateProfileVC.token = token
        updateProfileVC.isOwner = false
        
        self.navigationController?.pushViewController(updateProfileVC, animated: true)
        
        
    }
    
    @IBAction func goToMain(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if(!isOwner){
        let userMainVC = storyboard.instantiateViewController(identifier: "UserMainVC") as! UserMainViewController
        
        userMainVC.token = token
        userMainVC.userName = name
      
        self.navigationController?.pushViewController(userMainVC, animated: true)
        }else{
            let ownerMainVC = storyboard.instantiateViewController(identifier: "OwnerMainVC") as! OwnerMainViewController
            
            ownerMainVC.token = token
            ownerMainVC.name = name
          
            self.navigationController?.pushViewController(ownerMainVC, animated: true)
            
            
            
        }
        
        
    }
    
    
//    @IBAction func goToAllAtores(){
//
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let allStoresVC = storyboard.instantiateViewController(identifier: "AllStoresVC") as! AllStoresTableViewController
//
//        allStoresVC.token = token
//
//        self.navigationController?.pushViewController(allStoresVC, animated: true)
//
//
//    }
    
//    @IBAction func goToSubscribedStores(){
//
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let subscribedStoresVC = storyboard.instantiateViewController(identifier: "SubscribedStoresVC") as! SubscribedStoresTableViewController
//
//        subscribedStoresVC.token = token
//
//        self.navigationController?.pushViewController(subscribedStoresVC, animated: true)
//
//
//    }
    
    
    @IBAction func goToTemp(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let userMainVC = storyboard.instantiateViewController(identifier: "UserMainVC") as! UserMainViewController
        
        userMainVC.token = token
        
        self.navigationController?.pushViewController(userMainVC, animated: true)
        
        
    }
    
    
}
