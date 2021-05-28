//
//  OwnerMainViewController.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-05-24.
//

import SideMenu
import UIKit
var groToken = ""
var menu: SideMenuNavigationController?

class OwnerMainViewController: UIViewController {
    

    
    
    @IBOutlet var lblUserName : UILabel!
    
    var token : String = ""
    var name : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblUserName.text = name + " Owner !"
        
        // Do any additional setup after loading the view.
        
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        groToken = token
    }
    
    
    
    @IBAction func didTapMenu(){
        present(menu!, animated: true)
    }
    
    class MenuListController: UITableViewController{
        
        
        let url = URL(string: "https://sundaland.herokuapp.com/api/stores")!
        
        var items = ["", "Owner Information", "Add New Store", "", "Sign out"]
        
        let darkColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
        
        var newStore = Stores()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.backgroundColor = darkColor
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
        
        private func displayAddNewStorePopup(title: String, message: String){
           
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addTextField{(textField: UITextField) in
                textField.placeholder = "Name"
                textField.keyboardType = .default
                textField.autocorrectionType = .yes
            }
            alert.addTextField{(textField: UITextField) in
                textField.placeholder = "Address"
                textField.keyboardType = .default
                textField.autocorrectionType = .yes
            }
            alert.addTextField{(textField: UITextField) in
                textField.placeholder = "Province"
                textField.keyboardType = .default
                textField.autocorrectionType = .yes
            }
            alert.addTextField{(textField: UITextField) in
                textField.placeholder = "City"
                textField.keyboardType = .default
                textField.autocorrectionType = .yes
            }
            alert.addTextField{(textField: UITextField) in
                textField.placeholder = "Postal Code"
                textField.keyboardType = .default
                textField.autocorrectionType = .yes
            }
            alert.addTextField{(textField: UITextField) in
                textField.placeholder = "Country"
                textField.keyboardType = .default
                textField.autocorrectionType = .yes
            }
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                if let nameText = alert.textFields?[0].text, let addressText = alert.textFields?[1].text,
                   let provinceText = alert.textFields?[2].text, let cityText = alert.textFields?[3].text
                   , let postalCodeText = alert.textFields?[4].text, let countryText = alert.textFields?[5].text{
                    
                    
                    
                    self.newStore.name = nameText
                    self.newStore.streetAddress = addressText
                    self.newStore.province = provinceText
                    self.newStore.city = cityText
                    self.newStore.postalCode = postalCodeText
                    self.newStore.country = countryText
                  
                    
                    
                    //fetch to database
                    self.addNewStoreDatabase()
                    
                
                }
                
                
                
            }))
            
            
            self.present(alert, animated: true, completion: nil)
        }
        
        func addNewStoreDatabase() {

            //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid

            let parameters = ["name": newStore.name, "city" : newStore.city, "country": newStore.country, "postalCode": newStore.postalCode, "province" : newStore.province, "streetAddress" : newStore.streetAddress ] as Dictionary<String, AnyObject>

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
            request.addValue("Bearer " + groToken, forHTTPHeaderField: "Authorization")
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
                profileVC.token = groToken
                
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
            if (indexPath.row == 2){
                
                self.displayAddNewStorePopup(title: "Add New Store", message: "Enter the new store information")
                
            }
            
            if (indexPath.row == 4){
                
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let loginVC = storyboard.instantiateViewController(identifier: "LoginVC") as! LoginViewController
                loginVC.token = ""
                
                self.navigationController?.pushViewController(loginVC, animated: true)
                
                
            }
            
        }

    }
    
    
}




