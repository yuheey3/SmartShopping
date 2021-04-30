//
//  Stores.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-04-30.
//

import Foundation

class Stores : Codable{
    var name : String
    var city : String
    var country : String
    var postalCode : String
    var province : String
    var streetAddress : String
    
    init(name: String, city: String, country: String, province: String, postalCode: String, streetAddress: String){
        
        self.name = name
        self.city = city
        self.country = country
        self.postalCode = postalCode
        self.province = province
        self.streetAddress = streetAddress
    
    }
    
  

}
