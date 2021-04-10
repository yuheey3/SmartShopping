//
//  Task.swift
//  TheToDo
//
//  Created by Jigisha Patel on 2021-02-09.
//

import Foundation

class Task{
    var title: String
    var subtitle: String
    var done: Bool
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.done = false
    }
}

extension Task{
    public class func getInitialData() -> [Task]{
        return [
            Task(title: "Table View", subtitle: "Add Rows"),
            Task(title: "Stay Healthy", subtitle: "Drink Water"),
            Task(title: "Relax", subtitle: "Take a dog for walk")
        ]
    }
}
