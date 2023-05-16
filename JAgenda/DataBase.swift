//
//  Database.swift
//  JAgenda
//
//  Created by Jorah on 2023/1/13.
//

import Foundation
import SwiftUI

var encoder = JSONEncoder()
var decoder = JSONDecoder()

func initUsrData() -> [Item]{
    formatter.dateFormat = "MM-dd HH:mm"
    
    var re: [Item] = []
    if let dataStored = UserDefaults.standard.object(forKey: "JAgendaData1") as? Data {
        let data = try! decoder.decode([Item].self, from: dataStored)
        for item in data {
            re.append(Item(title: item.title, dueDate: item.dueDate, place: item.place, isDone: item.isDone, id: item.id, deleted: item.deleted))
        }
    }
    return re
}

class Database: ObservableObject {
    
    @Published var list: [Item]
    
    var cnt: Int = 0;
    
    var timer: Timer? = nil
    
    init(){
        self.list = []
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(60), repeats: true, block:{(timer: Timer) -> Void in
            self.refresh()
        })
        timer?.fire()
        
        refresh()
    }
    
    init(data: [Item]) {
        self.list = []
        for item in data{
            self.list.append(Item(title: item.title, dueDate: item.dueDate, place: item.place, isDone: item.isDone, id: item.id, deleted: item.deleted))
            cnt += 1
        }
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(60), repeats: true, block:{(timer: Timer) -> Void in
            self.refresh()
        })
        timer?.fire()
        
        refresh()
    }
    
    func clear(){
        self.list = []
        
        refresh()
    }
    
    func add(data: Item){
        self.list.append(Item(title: data.title, dueDate: data.dueDate, place: data.place, isDone: false, id: self.cnt, deleted: false))
        self.cnt += 1
        
        refresh()
    }
    
    func edit(id: Int, data: Item){
        self.list[id].title = data.title
        self.list[id].dueDate = data.dueDate
        self.list[id].place = data.place
        
        refresh()
    }
    
    func delete(id: Int){
        self.list[id].deleted = true
        
        refresh()
    }
    
    func refresh(){
        self.sort()
        self.dataStore()
        self.helper()
    }
    
    func sort(){
        self.list.sort(by: {
            (data1, data2) in
            if data1.isDone && !data2.isDone{
                return false
            }
            if !data1.isDone && data2.isDone{
                return true
            }
            return data1.dueDate.timeIntervalSince1970 < data2.dueDate.timeIntervalSince1970
        })
        for i in 0..<self.list.count{
            self.list[i].id = i
        }
    }
    
    func dataStore(){
        let dataStored = try! encoder.encode(self.list)
        UserDefaults.standard.set(dataStored, forKey: "JAgendaData1")
    }
    
    func helper(){
        tmp = []
        for item in self.list {
            if !item.deleted && item.isDone || !item.deleted && item.overdue(curDate: Date()){
                tmp.append(item)
            }
        }
        tmp.sort(by: {
            (d1, d2) in
            if d1.isDone && !d2.isDone {
                return false
            }
            if !d1.isDone && d2.isDone {
                return true
            }
            if d1.isDone && d2.isDone {
                return d1.dueDate.timeIntervalSince1970 > d2.dueDate.timeIntervalSince1970
            }
            return d1.dueDate.timeIntervalSince1970 < d2.dueDate.timeIntervalSince1970
        })
    }
    
}
