//
//  SubscribedStoresTableViewController.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-05-07.
//

import UIKit

class SubscribedStoresTableViewController: UITableViewController {
    var url = URL(string: "https://sundaland.herokuapp.com/api/stores")!
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
        
        self.navigationItem.title = "Subscribed Stores"
    
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_SubscribedStores", for: indexPath) as! SubscribedStoresCell
        
        // Configure the cell...
        if indexPath.row < storeList.count{
            
            let stores = storeList[indexPath.row]
            cell.lblName.text = stores.name
            cell.lblCity.text = stores.city
            cell.lblCountry.text = stores.country
            cell.lblProvince.text = stores.province
            cell.lblPostalCode.text = stores.postalCode
            cell.lblStreetAddress.text = stores.streetAddress
        
    
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
    
  
}
