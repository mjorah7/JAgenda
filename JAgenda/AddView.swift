//
//  AddView.swift
//  JAgenda
//
//  Created by Jorah on 2023/1/14.
//

import SwiftUI

struct AddView: View {
    
    @EnvironmentObject var userData: Database
    
    @Environment(\.presentationMode) var presenation
    
    @State var title: String = ""
    @State var duoDate: Date = Date()
    @State var place: String = ""
    
    var id : Int? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("things")){
                    TextField("title", text: self.$title)
                    TextField("place", text: self.$place)
                    DatePicker(selection: self.$duoDate, label: {Text("DDL")})
                }
                Section(header: Text("option")){
                    Button(action: {//confirm
                        if(self.id == nil){
                            userData.add(data: Item(title: self.title, dueDate: self.duoDate, place: self.place))
                        }else{
                            userData.edit(id: self.id!, data: Item(title: self.title, dueDate: self.duoDate, place: self.place))
                        }
                        self.presenation.wrappedValue.dismiss()
                    }){
                        Text("confirm")
                    }
                    
                    if let i = id {
                        if userData.list[i].isPartTwo() {
                            Button(action: {//undone
                                userData.list[i].toggle()
                                userData.refresh()
                                self.presenation.wrappedValue.dismiss()
                            }){
                                userData.list[i].isDone ? Text("undo") : Text("do")
                            }
                        }
                    }
                    
                    if self.id != nil {
                        Button(action: {//delete
                            userData.delete(id: self.id!)
                            self.presenation.wrappedValue.dismiss()
                        }){
                            Text("delete")
                                .foregroundColor(Color.red)
                        }
                    }
                }
                Section(header: Text("cancel")){
                    Button(action: {//cancel
                        self.presenation.wrappedValue.dismiss()
                    }){
                        Text("cancel")
                    }
                }
            }
            .navigationBarTitle(self.id == nil ? Text("Add") : Text("Edit"))
        }
    }
    
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
