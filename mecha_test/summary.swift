//
//  summary.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/14.
//


//
//  streamView2.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/10.
//

// 受け取りを関数かしようとしている
import SwiftUI
import Network    // UDP
import CoreMotion // yaw pich roll
import Foundation // timer

struct summary: View {
    @ObservedObject var Stream = streamFrames()
    @ObservedObject var GYRO = gyro_sensor()
    
    var body: some View {
        ZStack{
            VStack{
                
                if let uiImage = UIImage(data: Stream.img_data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 600, height: 600)
                        .border(.black, width: 2)
                        .rotationEffect(.degrees(-60 * GYRO.self.pitch))
                        .offset(y:  (GYRO.self.roll + 2) * -120)
                        .padding(.top,20)
                }
                else{
                    Image("back_gray")
                        .resizable()
                        .frame(width: 600, height: 600)
                        .border(.black, width: 2)
                        .rotationEffect(.degrees(-60 * GYRO.self.pitch))
                        .offset(y:(GYRO.self.roll + 2) * -120)
                        .padding(.top,20)
                }
                
            }
            VStack{
                Text("this is img from PC/RasPi")
                    .padding(.top, 20)
                Spacer()
            }
        }.onAppear{
         
        }
        .onDisappear{
   
        }
    }
}

// MARK: STREAM CLASS
class streamFrames : ObservableObject {
    @Published var img_data: Data = Data()
    var img_stock = Data()
    var img_previ = Data()
    var count     = 0
    
    var udpListener:NWListener?
    var backgroundQueueUdpListener   = DispatchQueue(label: "udp-lis.bg.queue", attributes: [])
    var backgroundQueueUdpConnection = DispatchQueue(label: "udp-con.bg.queue", attributes: [])
            
    var connections = [NWConnection]()
    func viewDidLoad() {
        startReceive(self)
    }
    
    
    func startReceive(_ sender: Any) {
        
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
    
    
    func stopReceive(_ sender: Any) {
        udpListener?.cancel()
    }
    
  // 他のクラスで作る必要があるかもしれない
    func processData(_ incomingUdpConnection :NWConnection) {
        incomingUdpConnection.receiveMessage(completion: {(data, context, isComplete, error) in
        
            if let data = data, !data.isEmpty {
                if let string = String(data: data, encoding: .ascii) {
                    if(string == "__end__"){//encode data comparing
// MARK: 送信画像サイズを変えたら確認！
                        if(self.count == 18){
                            self.img_data = self.img_stock
                        }
                        self.img_stock = Data()
                        self.count = 0
                    }
                    else{
                        self.count += 1
                        self.img_stock.append(data)
//                        self.img_data = data // 一回の時
                    }
                }
            }

            if error == nil {
                self.processData(incomingUdpConnection)
            }
        })
        
    }
    
   
}



// MARK: GYRO CLASS
class gyro_sensor : ObservableObject {

    private let motionManager = CMMotionManager()
    @Published var yaw: Double = 0.0
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @ObservedObject var contoroller = sendMessage()
    
    func startMotion() {
        contoroller.self.connect()
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main){
                data, error in
                guard let data else { return }
                self.yaw = data.attitude.yaw
                self.pitch = data.attitude.pitch
                self.roll = data.attitude.roll
                
                let message = String(self.pitch)
                self.contoroller.self.send(message.data(using: .utf8)!)
            }
        }
    }
    // end of the getting data　YPR
    func stopMotion() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
        if motionManager.isDeviceMotionActive{
            motionManager.stopDeviceMotionUpdates()
        }
        self.contoroller.self.disconnect()
    }
    
    
}





// MARK: SEND CLASS
class sendMessage: ObservableObject{
    @Published var message = "0,0,0,0"
    var connection: NWConnection? = nil
// MARK: ポート番号　ここに書く
    var host: NWEndpoint.Host = "192.168.0.31"
    var port: NWEndpoint.Port = 8008
    
    var timer :Timer?
    var count: Int = 0

    
    func startSend(){
        self.connect()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.println()
            self.send(self.message.data(using: .utf8)!)
        }
    }
    func println(){
        count += 1
        print(count)
    }
    func stopSend(){
        timer?.invalidate()
        self.disconnect()
    }
    
    // 参考URLと変更あり　connection！.send→　if conncition != nil && connection?.send(...
    func send(_ payload: Data) {
        if connection != nil {
            connection?.send(content: payload, completion: .contentProcessed({ sendError in
                if let error = sendError {
                    NSLog("Unable to process and send the data: \(error)")
                } else {
                    NSLog("Data has been sent")
                    self.connection!.receiveMessage { (data, context, isComplete, error) in
                        guard let myData = data else { return }
                        NSLog("Received message: " + String(decoding: myData, as: UTF8.self))
                        print(type(of: data))
                        
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
    
    func disconnect()
    {
        /* コネクション切断 */
        connection?.cancel()
    }
}




struct summary_Previews: PreviewProvider {
    static var previews: some View {
        summary()
    }
}
