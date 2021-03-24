//
//  DatabaseHelper.swift
//  TheToDo
//
//  Created by Yuki Waka on 2021-03-23.
//
//yuki
import Foundation
import CoreData
import UIKit

class DatabaseHelper{
    
    //singleton instance
    private static var shared : DatabaseHelper?
    
    static func getInstance() -> DatabaseHelper{
        
        if shared != nil{
            //instance already exists
            return shared!
        }else{
            //create a new singleton instance
            return DatabaseHelper(context: (UIApplication.shared.delegate as! AppDelegate)
                                    .persistentContainer.viewContext)
        }
    }
    
    private let moc : NSManagedObjectContext
    
    private init (context : NSManagedObjectContext){
        self.moc = context
    }
}


