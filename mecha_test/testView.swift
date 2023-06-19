//
//  testView.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/03.
//

import SwiftUI
// 高さと横幅を取得する
struct testView: View {
    var body: some View {
        let bounds = UIScreen.main.bounds
        let Swidth  = bounds.width
        let Sheight = bounds.height
        let buttonSize = bounds.width / 11
        let mid_b = bounds.width / 27
        
        ZStack{
            HStack {
                Text("幅:\(Int(Swidth))")
                    .font(.title)
                    .padding()
                Text("高さ:\(Int(Sheight))")
                    .font(.title)
                    .padding()
            }//H
            HStack{
                Button {
                    print("gray")
                } label: {
                    Image("gray_button")
                        .resizable()
                        .frame(width: buttonSize,height: buttonSize)
                }
                .offset(x:-Swidth / 4,y:Sheight / 6)
                VStack{
                    Button {
                        print("gray")
                    } label: {
                        Image("green_button")
                            .resizable()
                            .frame(width: buttonSize,height: buttonSize)
                    }
                    HStack{
                        Button {
                            print("gray")
                        } label: {
                            Image("red_button")
                                .resizable()
                                .frame(width: buttonSize,height: buttonSize)
                        }
                        .padding(.trailing, mid_b)
                        Button {
                            print("gray")
                        } label: {
                            Image("blue_button")
                                .resizable()
                                .frame(width: buttonSize,height: buttonSize)
                        }
                        .padding(.leading, mid_b)
                    }
                    Button {
                        print("gray")
                    } label: {
                        ZStack{
                            Image("yellow_button")
                                .resizable()
                                .frame(width: buttonSize,height: buttonSize)
                            Text("hell")
                        }
                    }
                    
                }
                .offset(x:Swidth / 4,y:Sheight / 6)

            }
        }//Z
    }
}


struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
    }
}
