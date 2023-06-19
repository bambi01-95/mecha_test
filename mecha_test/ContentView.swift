//
//  ContentView.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/02.
//

import SwiftUI
import Network
import Foundation
import CoreMotion

struct ContentView: View {
    let screenWidth:CGFloat = UIScreen.main.bounds.width

    var body: some View {
        
        //ZStack{
            NavigationView {
                //VStack{

                    // SecondView()をdestinationとする
                    List {
                        Section( header: Text("道のり")) {
                            NavigationLink(destination: secondView()) {
                                Text("スティック　コントローラ")
                            }
//                            NavigationLink(destination: thirdView()) {
//                                Text("ジャイロセンサ")
//                            }
                            NavigationLink(destination: thirdhalf()) {
                                Text("ジャイロ　コントローラ")
                            }
//                            NavigationLink(destination: fourthView()) {
//                                Text("文字列を送る")
//                            }
                            
//                            NavigationLink(destination: fifthView()) {
//                                Text("IP PORT 保存")
//                            }
                            
//                            NavigationLink(destination: sixthView()) {
//                                Text("動画受信 UDP Network")
//                            }
//                            NavigationLink(destination: sevenView()) {
//                                Text("画像受け取り成功")
//                            }
//                            NavigationLink(destination: streamView()) {
//                                Text("Object class")
//                            }
                            //secess
//                            NavigationLink(destination: streamView2()) {
//                                Text("controler this")
//                            }
                            
                            NavigationLink(destination: VRView()) {
                                Text("VR test")
                            }
                            NavigationLink(destination: test5()) {
                                Text("home")
                            }
                        }
                    }
                    
                    
                //}

            }

        //}
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

