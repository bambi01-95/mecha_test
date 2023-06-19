//
//  test2View.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/17.
//

import SwiftUI
//配置のテスト
struct test2View: View {
    
    var body: some View {
        let bounds = UIScreen.main.bounds
        let Swidth  = bounds.width
        let Sheight = bounds.height
        
        ZStack{
            VStack{
                // background
                Image("home_back")
                    .resizable()
                    .frame(width: Swidth + Swidth / 30 ,height: Sheight + Sheight / 20)
                    .clipped()
                    .offset(x:0,y:0)
            }
            
            
            // main cond
            HStack{
                // left
                VStack{
                    Image("back_gray")
                        .resizable()
                        .frame(height: Sheight * 4 / 7)
                    Image("back_gray")
                        .resizable()
                        .frame(height: Sheight * 2 / 7)
 
                }
                .frame(width: Swidth * 6 / 10,height: Sheight)
                // right
                VStack{
                    Image("back_gray")
                        .resizable()
                        .frame(height: Sheight * 2 / 14)
                    Image("back_gray")
                        .resizable()
                        .frame(height: Sheight * 5 / 14)
                    Image("back_gray")
                        .resizable()
                        .frame(height: Sheight * 5 / 14)

                }
                .frame(width: Swidth * 3 / 10,height: Sheight)
            }
        }
    }
}

struct test2View_Previews: PreviewProvider {
    static var previews: some View {
        test2View()
    }
}
