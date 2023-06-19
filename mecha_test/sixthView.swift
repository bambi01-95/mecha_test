//
//  sixthView.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/07.
//

import SwiftUI
import Network


// https://www.radical-dreamer.com/programming/nwconnection-swift/
// receive image by UDP data
struct sixthView: View {
    @State var connection: NWConnection? = nil
    // 送り先のIP addr & port num
    var host: NWEndpoint.Host = "192.168.0.23"
    var port: NWEndpoint.Port = 8080
    @State var img_str: String = "受け取ってない"
    
    var body: some View{
        VStack{
            Spacer()
            Text(img_str)
            Spacer()
            Button("Receive") {
                NSLog("Recive pressed")
                recv()
            }
            Spacer()
        }
        .onAppear{
            connect()
        }
        .onDisappear{
            disconnect()
        }
    }
    
    
    
    func recv() {
        /* データ受信 */
        if connection != nil{
            print("try recv")
            connection?.receive(minimumIncompleteLength: 0,
                                maximumLength: 65535,
                                completion:{(data, context, flag, error) in
                print("here")
                if let error = error {
                    NSLog("\(#function), \(error)")
                    print("error")
                } else {
                    if let data = data {
                        print("data in")
                        /* 受信データのデシリアライズ */
                        img_str = String(data: data, encoding: .utf8) ?? "not received data"
                        recv()
                    }
                    else {
                        NSLog("receiveMessage data nil")
                        print("data out")
                    }
                }
            })
        }
        print("end recv")
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
    
    func disconnect()
    {
        /* コネクション切断 */
        connection?.cancel()
    }
}
// https://qiita.com/k-yamada-github/items/d4c5cfa213e82656b82d
// this code fix the above problem

struct sixthView_Previews: PreviewProvider {
    static var previews: some View {
        sixthView()
    }
}
