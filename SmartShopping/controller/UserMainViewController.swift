//
//  AllStoresViewController.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-05-21.
//
import SideMenu
import UIKit
var grobalToken = ""

class UserMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    var menu: SideMenuNavigationController?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblUserName : UILabel!
    
    var url = URL(string: "https://sundaland.herokuapp.com/api/stores/all")!
   // var url = URL(string: "https://sundaland.herokuapp.com/api/stores")!
    
    var storeList:[Stores] = []
    var finalArray:[Any] = []
    var token : String = ""
    var userName = ""
    var name = ""
    var city = ""
    var country = ""
    var postalCode = ""
    var province = ""
    var streetAddress = ""
    
    var storeId : String = ""
    
 
    override func viewDidLoad() {
        
       
        submitToDatabase()
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 106
        
        tableView.isHidden = true
        
        lblUserName.text = userName
        
        menu = SideMenuNavigationController(rootViewController: MenuListController())
      
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        grobalToken = token
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapMenu(){
        present(menu!, animated: true)
    }
    
    class MenuListController: UITableViewController{
     
        func passingName(string: String) {
           print("Notified")
        }
        var delegate = ""
        
        var items = ["", "User Information", "", "Sign out"]
        
        let darkColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.backgroundColor = darkColor
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return items.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = items[indexPath.row]
            cell.textLabel?.textColor = .white
            cell.backgroundColor = darkColor
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            //do something
            
          
            if (indexPath.row == 1){
            
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let profileVC = storyboard.instantiateViewController(identifier: "ProfileVC") as! UserProfileViewController
                   profileVC.token = grobalToken
            
                self.navigationController?.pushViewController(profileVC, animated: true)

            }
            if (indexPath.row == 3){
                
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let loginVC = storyboard.instantiateViewController(identifier: "LoginVC") as! LoginViewController
                loginVC.token = ""
                
                self.navigationController?.pushViewController(loginVC, animated: true)
                
                
            }
            
        }
        
    
        
    }
    
    @IBAction func viewAllStoreList(){
        url = URL(string: "https://sundaland.herokuapp.com/api/stores/all")!
        submitToDatabase()
        tableView.isHidden = false
      
    }
    
    
    @IBAction func viewSubscribedStoreList(){
        url = URL(string: "https://sundaland.herokuapp.com/api/stores")!
        submitToDatabase()
        tableView.isHidden = false
      
    }

  func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storeList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < self.storeList.count{
            let stores = self.storeList[indexPath.row]
            name = stores.name
            city = stores.city
            country = stores.country
            province = stores.province
            postalCode = stores.postalCode
            streetAddress = stores.streetAddress
            storeId = stores.id
            goToStoreDetailPage()
            
            //tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allStoreCell", for: indexPath) as! AllStoreCell
        
        // Configure the cell...
        if indexPath.row < storeList.count{
            
            let stores = storeList[indexPath.row]
            cell.lblName.text = stores.name
            cell.lblAddress.text = stores.streetAddress + ", " + stores.city + ", " + stores.province + ", " + stores.country
           // cell.lblCountry.text = stores.country
           // cell.lblProvince.text = stores.province
          //  cell.lblPostalCode.text = stores.postalCode
        //    cell.lblStreetAddress.text = stores.streetAddress
            
            
            let accessory: UITableViewCell.AccessoryType = stores.checkMark ? .checkmark : .none
            if(stores.checkMark){
                storeId = stores.id
            }
            
            cell.accessoryType = accessory
            
        }
        return cell
    }
    
    func submitToDatabase() {
        storeList = []
        finalArray = []
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
                        DispatchQueue.main.async {
                            
                        self.tableView.reloadData()
                        }
                    }
                    
                }
                
                
            } catch let error as NSError {
                print(error.localizedDescription)
               
            }
        })
        
        // execute the HTTP request
        task.resume()
        
        
        
    }
    
    
   
   
        
        

    
    
    
    //    func askConfirmation(){
    //        let confirmAlert = UIAlertController(title: "Confirmation", message: "Would you like to subscribe selected stores?", preferredStyle: .actionSheet)
    //
    //        confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
    //            self.addStoreToUser()
    //            self.goToProfilePage()
    //        }))
    //
    //        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    //        self.present(confirmAlert,animated: true, completion: nil)
    //    }
    
    func goToProfilePage(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileVC = storyboard.instantiateViewController(identifier: "ProfileVC") as! UserProfileViewController
        profileVC.token = token
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
   
    
    func goToStoreDetailPage(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let storeDetailVC = storyboard.instantiateViewController(identifier: "StoreDetailVC") as! StoreDetailViewController
        storeDetailVC.name = name
        storeDetailVC.city = city
        storeDetailVC.country = country
        storeDetailVC.postalCode = postalCode
        storeDetailVC.province = province
        storeDetailVC.streetAddress = streetAddress
        storeDetailVC.id = storeId
        storeDetailVC.token = token
        self.navigationController?.pushViewController(storeDetailVC, animated: true)
        
    }
    
    
    
}
