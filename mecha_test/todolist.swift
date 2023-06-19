//
//  todolist.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/07.
//

import SwiftUI

struct todolist: View {
    @State var newItem: String = ""
    @State var toDoList: [String] = ["買い物","洗濯物"]
    @State var selectedItem: String = ""
    var body: some View {
        VStack{
            HStack{
                Text("新しい予定の追加")
                    .font(.largeTitle)
                    .padding(.leading)
                Spacer()
            }

            HStack{
                TextField("新しい予定を入力してください", text: $newItem)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width:300)
                Button {
                    self.toDoList.append(self.newItem)
                    self.newItem = ""
                    // 入れるもの、forkey:呼び出し用の名前
                    UserDefaults.standard.set(self.toDoList,forKey: "toDoList")
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 50, height: 30)
                        Text("追加")
                            .foregroundColor(.white)
                    }
                }

            }
            HStack{
                Text("To Do List")
                    .font(.largeTitle)
                    .padding(.leading)
            }
            List(toDoList, id: \.self){ item in
                Button {
                    selectedItem = item
                    
                } label: {
                    Text(item)
                }

            }
            Text(selectedItem)

            

            
        }.onAppear(){
            guard let defaultItem = UserDefaults.standard.array(forKey: "toDoList") as? [String]
            else {return}
            self.toDoList = defaultItem
        }

    }
}

struct todolist_Preview: PreviewProvider {
    static var previews: some View {
        todolist()
    }
}
