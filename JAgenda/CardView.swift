//
//  CardView.swift
//  JAgenda
//
//  Created by Jorah on 2023/1/13.
//

import SwiftUI

var formatter = DateFormatter()

struct CardView: View {
    
    @EnvironmentObject var userData: Database
    
    var index: Int
    
    @State var showAddView: Bool = false
    
    var remainingDays: String = "-1"
    
    var body: some View {
        
        HStack {
            //头部图标
            if self.userData.list[index].isDone{
                Rectangle()
                    .frame(width: 12)
                    .foregroundColor(.gray)
            } else if self.userData.list[index].overdue(curDate: Date()){
                Rectangle()
                    .frame(width: 12)
                    .foregroundColor(.red)
            } else {
                if self.userData.list[index].title.description.contains("#") {
                    Rectangle()
                        .frame(width: 12)
                        .foregroundColor(.green)
                } else if self.userData.list[index].place.count == 0 {
                    Rectangle()
                        .frame(width: 12)
                        .foregroundColor(.yellow)
                } else {
                    Rectangle()
                        .frame(width: 12)
                        .foregroundColor(.blue)
                }
            }
            
            //倒计时
            if !self.userData.list[index].deleted && !self.userData.list[index].isDone {
                VStack {
                    Text("due in")
                        .foregroundColor(.black)
                    Text(remainingDays)
                        .frame(width: 40)
                        .font(.title)
                        .foregroundColor(.black)
                    Text("days")
                        .foregroundColor(.black)
                }
                if self.userData.list[index].overdue(curDate: Date()){
                    Rectangle()
                        .frame(width: 2)
                        .foregroundColor(.red)
                }else if self.userData.list[index].title.description.contains("#") {
                    Rectangle()
                        .frame(width: 2)
                        .foregroundColor(.green)
                }else if self.userData.list[index].place.count == 0 {
                    Rectangle()
                        .frame(width: 2)
                        .foregroundColor(.yellow)
                } else {
                    Rectangle()
                        .frame(width: 2)
                        .foregroundColor(.blue)
                }
            }
            
            //信息栏
            Button(action: {
                self.showAddView = true
            }) {
                Group{
                    VStack(alignment: .leading, spacing: 6.0) {
                        Text(self.userData.list[index].title)
                            .font(.headline)
                            .fontWeight(.heavy)
                        let str = formatter.string(from: self.userData.list[index].dueDate)
                        HStack {
                            Text((str as NSString).substring(from: 6) == "23:59" ? (str as NSString).substring(to: 6) : str)
                            Spacer()
//                            Text(self.userData.list[index].place)
                            Text((self.userData.list[index].place as NSString).length > 4 ? (self.userData.list[index].place as NSString).substring(to: 3) + ".." : self.userData.list[index].place)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .foregroundColor(.black)
            }
            .sheet(isPresented: self.$showAddView, content: {
                AddView(title: self.userData.list[index].title, duoDate: self.userData.list[index].dueDate, place: self.userData.list[index].place, id: self.index)
                    .environmentObject(self.userData)
            })
            
            //完成按钮
            if userData.list[index].isPartOne() {
                Button(action: {
                    self.showAddView = true
                }){
                    Image(systemName: self.userData.list[self.index].isDone ? "checkmark.square.fill" : "square")
                        .padding(.trailing)
                        .imageScale(.large)
                        .foregroundColor(.black)
                        .onTapGesture {
                            self.userData.list[self.index].isDone.toggle()
                            self.userData.refresh()
                        }
                }
            }
            
        }
        .frame(height: 80)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10, x:0, y:10)
        
    }
    
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
