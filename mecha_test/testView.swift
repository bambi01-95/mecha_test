//
//  testView.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/03.
//

import SwiftUI

struct testView: View {
    // 送る側     /iPhone側
    @State private var from_ipaddr = ""
    @State private var from_portnum = ""
    // 受け取りがわ/RasPi
    @State private var to_ipaddr = ""
    @State private var to_portnum = ""
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    VStack{
                        Text("送信側 (iPhone/iPad)")
                        TextField("IP address", text: $from_ipaddr)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        TextField("Prot number", text: $from_ipaddr)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)//number only
                        Button {
                            //save data action here
                        } label: {
                            Text("決定")
                                .foregroundColor(Color.white)
                                .padding(.horizontal, 12)
                        }
                        .background(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 1)
                        )

                    }//L VStack
                    VStack{
                        Text("受信側　(RasPi/PC)")
                        TextField("IP address", text: $to_ipaddr)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        TextField("Port number", text: $to_ipaddr)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        Button {
                            //save data action here
                        } label: {
                            Text("決定")
                                .foregroundColor(Color.white)
                                .padding(.horizontal, 12)
                        }
                        .background(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 1)
                        )
                    }//R VStack
                    
                }//HStack
                //bottom button
                NavigationLink(destination: test()) {
                    Text("START")
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 1)
                        )
                }
            }
        }
    }
}

struct test: View {
    var body: some View{
        Text("ここにコントローラが来ます")
    }
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
    }
}
