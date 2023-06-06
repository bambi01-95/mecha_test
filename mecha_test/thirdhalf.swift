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
    private var frameWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    private let motionManager = CMMotionManager()
    
    @State private var yaw: Double = 0.0
    @State private var pitch: Double = 0.0
    @State private var roll: Double = 0.0
    
    
    var body: some View {
        
        ZStack{
            // 背景（ストリーミング画像の挿入場所）
            Image("back_gray")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            Image("Hline")// 水平ライン
                .resizable()
                .frame(maxWidth: frameWidth,maxHeight: 2)
                .rotationEffect(.degrees(-90 * pitch))
                .position(x: frameWidth / 2 - 40, y:100 * -roll + 50)//綺麗じゃない配置。。。
            // 傾きの値を表示
            VStack{
                Text("YPR")
                Text("yaw:\(yaw)")
                Text("pitch:\(pitch)")
                Text("roll:\(roll)")
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
                        
                    }label: {
                        Image("foward")
                            .resizable()
                            .frame(width:100, height: 60)
                    }
                    // blue bottom button
                    Button{
                        
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
