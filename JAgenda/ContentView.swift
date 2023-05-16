//
//  ContentView.swift
//  JAgenda
//
//  Created by Jorah on 2023/1/13.
//

import SwiftUI

var tmp: [Item] = []

struct ContentView: View {
    
    @ObservedObject var userData: Database = Database(data: initUsrData())
    
    @State var showAddPage: Bool = false
    
    var body: some View {
        
        NavigationView{
            ZStack {
                ScrollView(.vertical, showsIndicators: true){
                    HStack {
                        Text("Upcoming")
                        Spacer()
                    }
                    .font(.title)
                    .padding(.leading)
                    .padding(.top)
                    .padding(.top)
                    
                    Rectangle()
                        .frame(height: 3)
                        .padding(.horizontal)
                        .foregroundColor(.black)
                    
                    //未完成
                    VStack {
                        ForEach(self.userData.list){
                            item in
                            if !item.deleted && !item.isDone {
                                CardView(index: item.id, remainingDays: item.remainingDays())
                            }
                        }
                        .environmentObject(userData)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Finished")
                        Spacer()
                    }
                    .font(.title)
                    .padding(.leading)
                    .padding(.top)
                    .padding(.top)
                    
                    Rectangle()
                        .frame(height: 3)
                        .padding(.horizontal)
                        .foregroundColor(.black)
                    
                    //已完成或逾期
                    VStack {
                        ForEach(tmp){
                            item in
                            if !item.deleted && item.isDone {
                                CardView(index: item.id)
                            }
                        }
                        .environmentObject(userData)
                    }
                    .padding(.horizontal)
                }
                
                //添加图标
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showAddPage = true
                        }){
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80)
                                .foregroundColor(.green)
                                .padding(.trailing)
                        }
                        .sheet(isPresented: self.$showAddPage, content: {
                            AddView()
                                .environmentObject(self.userData)
                        })
                    }
                }
                .navigationBarTitle(Text("JAgenda"))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
