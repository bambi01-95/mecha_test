//
//  thirdhalf.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/06.
//

import SwiftUI
import CoreMotion
// UDP recive & stream
struct thirdhalf: View {
    @ObservedObject var Stream = streamFrames()
    @ObservedObject var Contoroller = sendMessage()
    @State var timer :Timer?
    @State var count: Int = 0
    @State var Lvec = 0.0
    @State var Rvec = 0.0
    
    private var frameWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    private let motionManager = CMMotionManager()
    
    @State private var yaw: Double = 0.0
    @State private var pitch: Double = 0.0
    @State private var roll: Double = 0.0
    
    @State var velocity:Double = 0.0

    var body: some View {
        let bounds = UIScreen.main.bounds
        let Sheight = bounds.height
        let d = -6 * Sheight / Double.pi
        ZStack{
            // 背景（ストリーミング画像の挿入場所）
            VStack{
                
                if let uiImage = UIImage(data: Stream.img_data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 700, height: 700)
                        .border(.black, width: 2)
                        .rotationEffect(.degrees(180 / Double.pi * -pitch))
                        .offset(y: (roll + Double.pi / 2) * d)
                        .padding(.top,20)
                }
                else{
                    Image("back_gray")
                        .resizable()
                        .frame(width: 700, height: 700)
                        .border(.black, width: 2)
                        .offset(y: (roll + Double.pi / 2) * d)
                        .rotationEffect(.degrees(180 / Double.pi * -pitch))
                        .padding(.top,20)
                }
            }
            
            VStack {
                Image("Hline")// 水平ライン
                .resizable()
                .frame(maxWidth: frameWidth,maxHeight: 2)
                .rotationEffect(.degrees(-90 * pitch))
                .padding(.top, 40)
                //.position(x: frameWidth / 2 - 40, y:100 * -roll + 50)//綺麗じゃない配置。。。
                Spacer()
            }
            // 傾きの値を表示
            VStack{
                Text("YPR")
                Text("yaw:\(yaw)")
                Text("pitch:\(pitch)")
                Text("roll:\(roll)")
                Text("velocity: \(velocity)")
                    .padding(.top)
                Text("Lvec:\(Lvec) Rvec:\(Rvec)")
                Text("d: \(pitch * d)")
            }
            .onAppear() {
                start()
            }
            .onDisappear() {
                stop()
            }
            //ボタンなど
            HStack{
                VStack{
                    // red top button
                    Button{
                        if(velocity>45){
                            velocity = 50
                        }
                        else{
                            velocity += 5
                        }
                    }label: {
                        Image("foward")
                            .resizable()
                            .frame(width:100, height: 60)
                    }
                    // blue bottom button
                    Button{
                        if(velocity < 5){
                            velocity = 0
                        }
                        else{
                            velocity -= 5
                        }
                    }label: {
                        Image("back")
                            .resizable()
                            .frame(width:100, height: 60)
                            
                    }
                    
                }
                .padding(.top, 100)
                Spacer()
            //右ボタン４種
                VStack{
              //上ボタン
                    Button {
                        print("top")
                    } label: {
                        Image("gray_button")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color.black)
                    }
                    .shadow(color: .black, radius: 5)
              //中ボタン
                    HStack{
                        //左ボたん
                        Button {
                            print("left")
                        } label: {
                            Image("yellow_button")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color.black)
                        }
                        .shadow(color: .black, radius: 5)
                        .padding(.trailing, 34)
                        // 右ボタン
                        Button {
                            print("right")
                        } label: {
                            Image("red_button")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color.black)
                        }
                        .shadow(color: .black, radius: 5)
                        .padding(.leading, 34)
                    }
            //下ボタン
                    Button {
                        print("bottom")
                    } label: {
                        Image("green_button")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color.black)
                    }
                    .shadow(color: .black, radius: 5)
                    
                    
                }
            }
        }
        .onAppear{
            start()
            Stream.self.startReceive(0)
            Contoroller.self.connect()
        }
        .onDisappear{
            stop()
            Stream.self.stopReceive(0)
            Contoroller.self.disconnect()
        }
    }

    // get the data　YPR
    func start() {
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main){
                data, error in
                guard let data else { return }
                yaw = data.attitude.yaw
                pitch = data.attitude.pitch
                roll = data.attitude.roll
                let limit = Double.pi / 4
                var alpha = 1 - (abs(pitch) / limit)
                if(alpha<0){
                    alpha = 0
                }
                if(0 < pitch){
                    Lvec = velocity
                    Rvec = velocity * alpha
                }
                else if(pitch < 0){
                    Lvec = velocity * alpha
                    Rvec = velocity
                }
                let message = String(Int(Lvec)) + "," + String(Int(Rvec))
                Contoroller.self.send(message.data(using:.utf8)!)
            }
        }
    }
    // end of the getting data　YPR
    func stop() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
        if motionManager.isDeviceMotionActive{
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
}
struct thirdhalf_Previews: PreviewProvider {
    static var previews: some View {
        thirdhalf()
    }
}
