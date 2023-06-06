//
//  secondView.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/02.
//
// 左スティック　＆　４ボタン
import SwiftUI

// 新規でViewを作成
struct secondView: View {
    @State var position: CGSize = CGSize(width: 100, height: 200)

    
    @State var arm: Int = 0
    @State var camera: Int = 0
    //buttonを掴んでいるかいないか
    @State var grab:Bool = false
    //範囲指定用の画像の初期位置
    @State var grabx:CGFloat = 100
    @State var graby:CGFloat = 200
    
    @State var locx:CGFloat = 0
    @State var locy:CGFloat = 0
    let c_range: Double = 50 //range of control button
    
    // dragの動きの定義
    var drag: some Gesture {
        DragGesture()
        //掴んでいる時の動作
        .onChanged{ value in
            // ボタンの触れた初期位置
            let startx = value.startLocation.x
            let starty = value.startLocation.y
            // ボタンの初期位置からの移動距離
            let transx = value.translation.width
            let transy = value.translation.height

            // ボタンが範囲を超えた時
            if(hypotenuse(transx,transy) > sqrt(c_range * c_range)){
                //接触している位置の角度
                let radian = atan2(transx,transy)
                locx = CGFloat(Int(c_range)) * sin(radian)
                locy = CGFloat(Int(c_range)) * cos(radian)
                self.position = CGSize(width: startx + locx, height: starty + locy)
            }
            else{// 範囲内
                self.position = CGSize(
                    width:  startx + transx,
                    height: starty + transy
                )
                locx = transx
                locy = transy
            }
            grab = true
            grabx = startx
            graby = starty
            print("xs:\(startx)")
            print("ys:\(starty)")
        }
        
        //話した時のの動作 初期位置に戻す
        .onEnded{ value in
            self.position = CGSize(
                width: 100,
                height: 200
            )
            locx = 0
            locy = 0
            grab = false
        }
        
        
    }
    
//main view
    var body: some View {
        
        ZStack{
            // 背景（ストリーミング画像の挿入場所）
            Image("back_gray")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            // センサーや入力値
            VStack{
                Text("xt:\(locx)")
                Text("yt:\(locy)")
                    .padding(.bottom,300)
            }
            HStack{
                ZStack{
      
                    // コントローラーの範囲視覚化
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 180, height: 180)
                        .foregroundColor(Color.blue)
                        .position(x: grab == false ? 100 : grabx, y:grab == false ? 200 : graby)
                        .opacity(0.06)
                    
                    
                    // 左のコントロールボタン
                    Image("blue_button")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .opacity(grab == true ? 1 : 0.8)
                        .offset(.zero)
                        .position(x: position.width, y: position.height)
                        .gesture(drag)
                        .shadow(color: .black, radius: 5)
//                        .animation(.spring(response: 0.9, dampingFraction: 1.0, blendDuration: 1),value: 1)
                }

                
                
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
    //sqrt(a,b)
    func hypotenuse(_ a: Double, _ b: Double) -> Double {
        return (a * a + b * b).squareRoot()
    }
    
}
struct secondView_Previews: PreviewProvider {
    static var previews: some View {
        secondView()
    }
}
