//
//  sevenView.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/08.
//

import SwiftUI
import Foundation
//import UIKit
import Network

//O　いじらないでおいく 2023/06/09のラインの状態
struct sevenView: View {
    @ObservedObject var Stream = streamFrame()
    let udp = ViewController1()
    var body: some View {
        VStack{
            Text("this is img from PC/RasPi")
            Text(udp.imgString.frame)
            if let uiImage = UIImage(data: udp.imgString.frame_d) {
                Image(uiImage: uiImage)
                    .frame(width: 300, height: 300)
                    .border(.black, width: 2)
                    .padding()
            }

        }.onAppear{
            udp.self.myOnButton(0)
        }
        .onDisappear{
            udp.self.myOffButton(0)
        }
    }
    
}

class streamFrame : ObservableObject {
    @Published var frame: String = ""
    @Published var frame_d: Data = Data()
}

// https://stackoverflow.com/questions/62622612/nwnetworking-nwlistener-how-to-correctly-receive-udp-broadcast-messages
// oops!!!
class ViewController1: UIViewController {
    @ObservedObject var imgString = streamFrame()
    
    var udpListener:NWListener?
    var backgroundQueueUdpListener   = DispatchQueue(label: "udp-lis.bg.queue", attributes: [])
    var backgroundQueueUdpConnection = DispatchQueue(label: "udp-con.bg.queue", attributes: [])
            
    var connections = [NWConnection]()
    var imgData_s = Data()
    var imgData_b = Data()
    override func viewDidLoad() {
        super.viewDidLoad()
        myOnButton(self)
    }
    
    
    func myOnButton(_ sender: Any) {
        
        guard self.udpListener == nil else {
            print(" 🧨 Already listening. Not starting again")
            return
        }
        
        do {
            self.udpListener = try NWListener(using: .udp, on: 8080)// port
            self.udpListener?.stateUpdateHandler = { (listenerState) in
                
                switch listenerState {
                case .setup:
                    print("Listener: Setup")
                case .waiting(let error):
                    print("Listener: Waiting \(error)")
                case .ready:
                    print("Listener: Ready and listens on port: \(self.udpListener?.port?.debugDescription ?? "-")")
                case .failed(let error):
                    print("Listener: Failed \(error)")
                case .cancelled:
                    print("Listener: Cancelled by myOffButton")
                    for connection in self.connections {
                        connection.cancel()
                    }
                    self.udpListener = nil
                default:
                    break;
                }
            }
            
            self.udpListener?.start(queue: backgroundQueueUdpListener)
            self.udpListener?.newConnectionHandler = { (incomingUdpConnection) in

                print ("💁 New connection \(incomingUdpConnection.debugDescription)")
                
                incomingUdpConnection.stateUpdateHandler = { (udpConnectionState) in
                    switch udpConnectionState {
                    case .setup:
                        print("Connection: setup")
                    case .waiting(let error):
                        print("Connection: waiting: \(error)")
                    case .ready:
                        print("Connection: ready")
                        self.connections.append(incomingUdpConnection)
                        self.processData(incomingUdpConnection)
                    case .failed(let error):
                        print("Connection: failed: \(error)")
                        self.connections.removeAll(where: {incomingUdpConnection === $0})
                    case .cancelled:
                        print("Connection: cancelled")
                        self.connections.removeAll(where: {incomingUdpConnection === $0})
                    default:
                        break
                    }
                }
                incomingUdpConnection.start(queue: self.backgroundQueueUdpConnection)
            }
        } catch {
            print("🧨")
        }
    }
    
    
    func myOffButton(_ sender: Any) {
        udpListener?.cancel()
    }
    
  
    func processData(_ incomingUdpConnection :NWConnection) {
        incomingUdpConnection.receiveMessage(completion: {(data, context, isComplete, error) in
        
            if let data = data, !data.isEmpty {
                if let string = String(data: data, encoding: .ascii) {
                    if(string == "__end__"){
                        print ("DATA       = \(string)")
                        self.imgData_b = self.imgData_s
                        self.imgString.frame_d = self.imgData_s
                        self.imgData_s = Data()
                    }
                    else{
                        print("DATA-get an img")
                        //self.imgData_s.append(data)
                        print ("DATA       = \(string)")
                        self.imgString.frame = string
                        self.imgString.frame_d = data
                        
                        self.imgData_s.append(data)
                    }
                }
            }

            if error == nil {
                self.processData(incomingUdpConnection)
            }
        })
        
    }
    
   
}


//class ExampleCode{
//    func send(connection: NWConnection) {
//        /* 送信データ生成 */
//        let message = "example\n"
//        let data = message.data(using: .utf8)!
//        let semaphore = DispatchSemaphore(value: 0)
//
//        /* データ送信 */
//        connection.send(content: data, completion: .contentProcessed { error in
//            if let error = error {
//                NSLog("\(#function), \(error)")
//            } else {
//                semaphore.signal()
//            }
//        })
//        /* 送信完了待ち */
//        semaphore.wait()
//    }
//
//    func recv(connection: NWConnection) {
//        let semaphore = DispatchSemaphore(value: 0)
//        print("start")
//        /* データ受信 */
//        connection.receive(minimumIncompleteLength: 0,
//                           maximumLength: 65535,
//                           completion:{(data, context, flag, error) in
//            if let error = error {
//                print("error")
//                NSLog("\(#function), \(error)")
//            } else {
//                if let data = data {
//                    print("get data")
//                    /* 受信データのデシリアライズ */
//                    semaphore.signal()
//                    let str = String(data: data, encoding: .utf8) ?? "not received data"
//                    print(str)
//                }
//                else {
//                    NSLog("receiveMessage data nil")
//                    print("NSLog")
//                }
//            }
//        })
//        print("end")
//        /* 受信完了待ち */
//        semaphore.wait()
//        print("end-end")
//    }
//
//    func disconnect(connection: NWConnection)
//    {
//        /* コネクション切断 */
//        connection.cancel()
//    }
//
//    func connect(host: String, port: String) -> NWConnection
//    {
//        let t_host = NWEndpoint.Host(host)
//        let t_port = NWEndpoint.Port(port)
//        let connection : NWConnection
//        let semaphore = DispatchSemaphore(value: 0)
//
//        /* コネクションの初期化 */
//        connection = NWConnection(host: t_host, port: t_port!, using: .udp)
//
//        /* コネクションのStateハンドラ設定 */
//        connection.stateUpdateHandler = { (newState) in
//            switch newState {
//                case .ready:
//                    NSLog("Ready to send")
//                    semaphore.signal()
//                case .waiting(let error):
//                    NSLog("\(#function), \(error)")
//                case .failed(let error):
//                    NSLog("\(#function), \(error)")
//                case .setup: break
//                case .cancelled: break
//                case .preparing: break
//                @unknown default:
//                    fatalError("Illegal state")
//            }
//        }
//
//        /* コネクション開始 */
//        let queue = DispatchQueue(label: "example")
//        connection.start(queue:queue)
//
//        /* コネクション完了待ち */
//        semaphore.wait()
//        return connection
//    }
//
//    func example()
//    {
//        // 相手側のアドレス
//        let connection : NWConnection
//        let host = "192.168.0.23"//"192.168.0.31"//
//        let port = "8080"
//
//        /* コネクション開始 */
//        connection = connect(host: host, port: port)
//        /* データ送信 */
////        send(connection: connection)
//        /* データ受信 */
//        recv(connection: connection)
//        /* コネクション切断 */
//        disconnect(connection: connection)
//    }
//}


struct sevenView_Previews: PreviewProvider {
    static var previews: some View {
        sevenView()
    }
}
