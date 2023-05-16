//
//  Item.swift
//  JAgenda
//
//  Created by Jorah on 2023/1/13.
//

import Foundation

struct Item: Identifiable, Codable {
    
    var title: String = "default"
    
    var dueDate: Date = Date()
    
    var place: String = ""
    
    var isDone: Bool = false
    
    var id: Int = 0
    
    var deleted: Bool = false
    
    static var cnt: Int = 0
    
    func overdue(curDate: Date) -> Bool {
        return dueDate.timeIntervalSince1970 < curDate.timeIntervalSince1970
//        return false
    }
    
    func overdue() -> Bool{
        return dueDate.timeIntervalSince1970 < Date().timeIntervalSince1970
//        return false
    }
    
    func remainingDays() -> String {
        let curDay: Int = Int(Date().timeIntervalSince1970) / 60 / 60 / 24
        let schDay: Int = Int(dueDate.timeIntervalSince1970) / 60 / 60 / 24
        return String(schDay - curDay)
    }
    
    func isPartTwo() -> Bool {
        return !self.deleted && self.isDone || !self.deleted && self.overdue(curDate: Date())
    }
    
    func isPartOne() -> Bool {
        return !self.deleted && !self.isDone && !self.overdue(curDate: Date())
    }
    
    mutating func toggle() {
        self.isDone.toggle()
    }
    
}
