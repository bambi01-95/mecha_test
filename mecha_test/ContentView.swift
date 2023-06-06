//
//  ContentView.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/02.
//

import SwiftUI
import Network
import CoreMotion

struct ContentView: View {
    var body: some View {
        VStack{
            NavigationView {
                VStack{

                    // SecondView()をdestinationとする
                    List{
                        Text("道のり").font(.system(size: 20))
                        NavigationLink(destination: secondView()) {
                            Text("ノーマルコントローラ")
                        }
                        NavigationLink(destination: thirdView()) {
                            Text("ジャイロコントローラーテスト")
                        }
                        NavigationLink(destination: thirdhalf()) {
                            Text("ジャイロコントローラー")
                        }
                        NavigationLink(destination: fourthView()) {
                            Text("UDP送る")
                        }
                        NavigationLink(destination: fifthView()) {
                            Text("IP PORT 保存")
                        }
                        NavigationLink(destination: sixthView()) {
                            Text("動画受信 UDP")
                        }
                    }
                    
                    
                }

            }

        }
    }

}


struct sixthView: View {
    var body: some View{
        Text("UDP streimng")
        
    }
}



// UDP send :https://twissmueller.medium.com/network-framework-swiftui-and-ryze-tello-7b844b8d1225
struct fourthView: View {
    // 拾ってきただけであまり理解していない
    // 参考URLと変更あり、　++ = nil
    @State var connection: NWConnection? = nil
        // 送り先のIP addr & port num
        var host: NWEndpoint.Host = "192.168.0.31"
        var port: NWEndpoint.Port = 8080
        
        var body: some View {
            VStack {
                Spacer()
                Button("Connect") {
                    NSLog("Connect pressed")
                    connect()
                }
                Spacer()
                Button("Send") {
                    NSLog("Send pressed")
                    send("left:100,right:100,arm:1,light2???".data(using: .utf8)!)
                }
                Spacer()
            }.padding()
        }
        // 参考URLと変更あり　connection！.send→　if conncition != nil && connection?.send(...
        func send(_ payload: Data) {
            if connection != nil {
                connection?.send(content: payload, completion: .contentProcessed({ sendError in
                    if let error = sendError {
                        NSLog("Unable to process and send the data: \(error)")
                    } else {
                        NSLog("Data has been sent")
                        connection!.receiveMessage { (data, context, isComplete, error) in
                            guard let myData = data else { return }
                            NSLog("Received message: " + String(decoding: myData, as: UTF8.self))
                        }
                    }
                }))
            } else {
                NSLog("Connection is nil")
            }
        }
        
        func connect() {
            connection = NWConnection(host: host, port: port, using: .udp)
            
            connection!.stateUpdateHandler = { (newState) in
                switch (newState) {
                case .preparing:
                    NSLog("Entered state: preparing")
                case .ready:
                    NSLog("Entered state: ready")
                case .setup:
                    NSLog("Entered state: setup")
                case .cancelled:
                    NSLog("Entered state: cancelled")
                case .waiting:
                    NSLog("Entered state: waiting")
                case .failed:
                    NSLog("Entered state: failed")
                default:
                    NSLog("Entered an unknown state")
                }
            }
            
            connection!.viabilityUpdateHandler = { (isViable) in
                if (isViable) {
                    NSLog("Connection is viable")
                } else {
                    NSLog("Connection is not viable")
                }
            }
            
            connection!.betterPathUpdateHandler = { (betterPathAvailable) in
                if (betterPathAvailable) {
                    NSLog("A better path is availble")
                } else {
                    NSLog("No better path is available")
                }
            }
            
            connection!.start(queue: .global())
        }
}
// if above code does not work, check/do https://stackoverflow.com/questions/54640996/how-to-work-with-udp-sockets-in-ios-swift



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

