//
//  Stores.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-04-30.
//

import Foundation

class Stores : Codable{
    var id : String
    var name : String
    var city : String
    var country : String
    var postalCode : String
    var province : String
    var streetAddress : String
    var checkMark: Bool
    
    
    init(){
        
        self.id = ""
        self.name = ""
        self.city = ""
        self.country = ""
        self.postalCode = ""
        self.province = ""
        self.streetAddress = ""
        self.checkMark = false
    
    }
    
    init(id: String, name: String, city: String, country: String, province: String, postalCode: String, streetAddress: String){
        
        self.id = id
        self.name = name
        self.city = city
        self.country = country
        self.postalCode = postalCode
        self.province = province
        self.streetAddress = streetAddress
        self.checkMark = false
    
    }
    
  

}
