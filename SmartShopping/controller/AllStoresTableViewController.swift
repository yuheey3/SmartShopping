//
//  AllStoresTableViewController.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-04-30.
//

import UIKit

class AllStoresTableViewController: UITableViewController {
    var url = URL(string: "https://sundaland.herokuapp.com/api/stores/all")!
    //private var storeList : [Stores] = []
    var storeList:[Stores] = []
    var finalArray:[Any] = []
    var token : String = ""
    var name = ""
    var storeId : String = ""
    
    
    override func viewDidLoad() {
        
        submitToDatabase()
        super.viewDidLoad()
        
   
        
        self.tableView.rowHeight = 269
        
        //fetch all the records and display in tableview
        
        
        
        self.navigationItem.title = "All Stores"
        
        let subscribeBtn = UIBarButtonItem(title: "Subscribe", style: .plain, target: self, action: #selector(subscribeStores))
        self.navigationItem.setRightBarButton(subscribeBtn, animated: true)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storeList.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if indexPath.row < self.storeList.count{
            let stores = self.storeList[indexPath.row]
            stores.checkMark.toggle()
         
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_allStores", for: indexPath) as! AllStoresCell
        
        // Configure the cell...
        if indexPath.row < storeList.count{
            
            let stores = storeList[indexPath.row]
            cell.lblName.text = stores.name
            cell.lblCity.text = stores.city
            cell.lblCountry.text = stores.country
            cell.lblProvince.text = stores.province
            cell.lblPostalCode.text = stores.postalCode
            cell.lblStreetAddress.text = stores.streetAddress
        
            
            let accessory: UITableViewCell.AccessoryType = stores.checkMark ? .checkmark : .none
            if(stores.checkMark){
                storeId = stores.id
            }
            
            cell.accessoryType = accessory
            
        }
        return cell
    }
    
    func submitToDatabase() {
        
        print(token)
        
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        // let parameters = ["token": token] as Dictionary<String, String>
        
        
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "GET" //set http method as POST
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { [self] data, response, error in
            
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            do {
                
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
                
                if let jsonArray = json as? [[String:Any]] {
                
                    
                    //print("json is array", jsonArray)
                    self.finalArray.append(jsonArray)
                    
                    // print(finalArray)for userDictionary in jsonarray{
                    for userDictionary in jsonArray{
                        guard let id = userDictionary["_id"] as? String,
                        let name = userDictionary["name"] as? String, let city = userDictionary["city"] as? String, let country = userDictionary["country"] as? String,let province = userDictionary["province"] as? String,let postalCode = userDictionary["postalCode"] as? String,let streetAddress = userDictionary["streetAddress"] as? String else { continue }
                        
                        storeList.append(Stores(id: id, name: name,city: city, country: country,province: province, postalCode: postalCode, streetAddress: streetAddress))
                        self.tableView.reloadData()
                        
                    }
                  
                }
                
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })
        
        // execute the HTTP request
        task.resume()
   
        
        
    }
    
    @objc
    func subscribeStores()
    {
       // self.navigationController?.popToRootViewController(animated: true)
        
        self.askConfirmation()
    }
 
    
    func askConfirmation(){
        let confirmAlert = UIAlertController(title: "Confirmation", message: "Would you like to subscribe selected stores?", preferredStyle: .actionSheet)
        
        confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.addStoreToUser()
            self.goToProfilePage()
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(confirmAlert,animated: true, completion: nil)
    }
    
    func goToProfilePage(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileVC = storyboard.instantiateViewController(identifier: "ProfileVC") as! UserProfileViewController
        profileVC.token = token
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    

    
    func addStoreToUser() {
        
        print(token)
        url = URL(string: "https://sundaland.herokuapp.com/api/users/store")!
        
        let parameters = ["storeId": storeId] as Dictionary<String, String>
        
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
                // self.isFoundUser = false
            }
        })
        task.resume()
        
    }
    
}

