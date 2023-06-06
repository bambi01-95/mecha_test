//
//  thirdView.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/03.
//

import SwiftUI
import CoreMotion
//ジャイロセンサーのテスト

// https://qiita.com/SNQ-2001/items/925567384e2783fb070a
struct thirdView: View{
    private let motionManager = CMMotionManager()
    @State private var x: Double = 0.0
    @State private var y: Double = 0.0
    @State private var z: Double = 0.0
    
    @State private var yaw: Double = 0.0
    @State private var pitch: Double = 0.0
    @State private var roll: Double = 0.0
    
    @State private var gyroX: Double = 0.0
    @State private var gyroY: Double = 0.0
    @State private var gyroZ: Double = 0.0
    
    var body: some View {
        HStack(spacing: 20) {
      
                VStack{
                    Text("acce")
                    Text("x: \(x)")
                    Text("y: \(y)")
                    Text("z: \(z)")
                }.padding()
                VStack{
                    Text("YPR")
                    Text("yaw:\(yaw)")
                    Text("pitch:\(pitch)")
                    Text("roll:\(roll)")
                }
                .padding()
                VStack{
                    Text("gyro")
                    Text("gyroX:\(gyroX)")
                    Text("gyroY:\(gyroY)")
                    Text("gyroZ:\(gyroZ)")
                }
                .padding()
        }
        .onAppear() {
            start()
        }
        .onDisappear() {
            stop()
        }
    }
    func start() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                guard let data else { return }
                x = data.acceleration.x
                y = data.acceleration.y
                z = data.acceleration.z
            }
        }
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main){
                data, error in
                guard let data else { return }
                yaw = data.attitude.yaw
                pitch = data.attitude.pitch
                roll = data.attitude.roll
                
                gyroX = data.rotationRate.x
                gyroY = data.rotationRate.y
                gyroZ = data.rotationRate.z
                
                
            }
        }
    }
    func stop() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
        if motionManager.isDeviceMotionActive{
            motionManager.stopDeviceMotionUpdates()
        }
    }
}

struct thirdView_Previews: PreviewProvider {
    static var previews: some View {
        thirdView()
    }
}
