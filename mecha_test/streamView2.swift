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

struct streamView2: View {
    @ObservedObject var Stream = streamFrames()
    
    @State private var yaw: Double = 0.0
    @State private var pitch: Double = 0.0
    @State private var roll: Double = 0.0
    @State var timer :Timer?
    @State var count: Int = 0

    private let motionManager = CMMotionManager()
    
    var body: some View {
        ZStack{
            VStack{
                
                if let uiImage = UIImage(data: Stream.img_data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 600, height: 600)
                        .border(.black, width: 2)
                        .rotationEffect(.degrees(-60 * pitch))
                        .offset(y:  (roll + 2) * -120)
                        .padding(.top,20)
                }
                else{
                    Image("back_gray")
                        .resizable()
                        .frame(width: 600, height: 600)
                        .border(.black, width: 2)
                        .rotationEffect(.degrees(-60 * pitch))
                        .offset(y:(roll + 2) * -120)
                        .padding(.top,20)
                }
                
            }
            VStack{
                Text("this is img from PC/RasPi")
                    .padding(.top, 20)
                Spacer()
            }
            
        }.onAppear{
            Stream.self.startReceive(0)
            startMotion()
            startSend()
        }
        .onDisappear{
            Stream.self.stopReceive(0)
            stopMotion()
            stopSend()
        }
    }
    
    func startMotion() {
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main){
                data, error in
                guard let data else { return }
                yaw = data.attitude.yaw
                pitch = data.attitude.pitch
                roll = data.attitude.roll
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
    }
    
    func startSend(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            println()
        }
    }
    func println(){
        count += 1
        print(count)
    }
    func stopSend(){
        timer?.invalidate()
    }

    
    
}

struct streamView2_Previews: PreviewProvider {
    static var previews: some View {
        streamView2()
    }
}
