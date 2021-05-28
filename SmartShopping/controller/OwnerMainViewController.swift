//
//  OwnerMainViewController.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-05-24.
//

import SideMenu
import UIKit
//var grobalToken = ""

class OwnerMainViewController: UIViewController {
    
    var menu: SideMenuNavigationController?
    
    
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
        
        grobalToken = token
    }
    
    @IBAction func didTapMenu(){
        present(menu!, animated: true)
    }
    
    class MenuListController: UITableViewController{
        
        var items = ["", "Owner Information", "Second", "Third", "option"]
        
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
            
        }

    }
    
}



