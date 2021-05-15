//
//  StoreDetailViewController.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-05-14.
//

import UIKit

class StoreDetailViewController: UIViewController {

    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblCity : UILabel!
    @IBOutlet var lblCountry : UILabel!
    @IBOutlet var lblProvince : UILabel!
    @IBOutlet var lblPostalCode : UILabel!
    @IBOutlet var lblStreetAddress : UILabel!
    @IBOutlet var imageView: UIImageView!

    
    var name = ""
    var city = ""
    var country = ""
    var province = ""
    var postalCode = ""
    var streetAddress = ""
    var id = ""
    var token = ""
    let starFill = UIImage(systemName: "star.fill")
    let star = UIImage(systemName: "star")
    var isSubscribed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = name
        lblCity.text = city
        lblCountry.text = country
        lblProvince.text = province
        lblPostalCode.text = postalCode
        lblStreetAddress.text = streetAddress
        

        let tap = UITapGestureRecognizer(target: self, action: #selector(StoreDetailViewController.addStoreToUser))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        
  
    
        // Do any additional setup after loading the view.
    }
    

    @objc func addStoreToUser() {
        if(isSubscribed){
            imageView.image = starFill
            isSubscribed = false
        }else{
            imageView.image = star
            isSubscribed = true
        }
        
        let url = URL(string: "https://sundaland.herokuapp.com/api/users/store")!
       // imageView.setImage( UIImage(named:"Unchecked.png"), forState: .Normal)
        imageView.image = starFill
        
        let parameters = ["storeId": id] as Dictionary<String, String>
        
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
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
