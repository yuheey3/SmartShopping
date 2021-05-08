//
//  User.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-03-28.
//

import Foundation

struct User : Codable{
    var name : String
    var email : String
    var password: String
    var isOwner : Bool
    var userAddress: UserAddress
    var token : String
    
    
    init() {
        self.name = ""
        self.email = ""
        self.password = ""
        self.userAddress = UserAddress()
        self.token = ""
        self.isOwner = false
    
    }
    
    init(name : String,email : String, password: String, isOwner: Bool, address: String, userAddress: UserAddress, token: String) {
        
        self.name = name
        self.email = email
        self.password = password
        self.isOwner = isOwner
        self.userAddress = userAddress
        self.token = token
     
    }
    
    struct UserAddress : Codable{
        var address : String
        var city : String
        var postalCode : String
        var country : String
        
        init(){
            self.address = ""
            self.city = ""
            self.postalCode = ""
            self.country = ""
            
        }
    }
}

