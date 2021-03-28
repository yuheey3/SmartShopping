//
//  User.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-03-28.
//

import Foundation

struct User{
    var email : String
    var name : String
    var password: String
    var isOwner : Bool
    
    init() {
        self.email = ""
        self.name = ""
        self.password = ""
        self.isOwner = false
     
    }
    
    init(email : String, name : String, password: String, isOwner: Bool) {
        
        self.email = email
        self.name = name
        self.password = password
        self.isOwner = isOwner
    
    }
}

