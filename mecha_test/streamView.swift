//
//  streamView.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/08.
//
/*  6月10日(土) test 中　*/
/*  6月11日(日) ほぼ完璧　*/
/* observar Frame でできるか*/
import SwiftUI
import Foundation
import Network


struct streamView: View {
    @ObservedObject var Stream = streamFrames()
    
    var body: some View {
        ZStack{
            VStack{
                
                if let uiImage = UIImage(data: Stream.img_data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 800, height: 800)
                        .border(.black, width: 2)
                        .padding(.top,20)
                }
                else{
                    Image("back_gray")
                        .resizable()
                        .frame(width: 800, height: 800)
                        .border(.black, width: 2)
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
        }
        .onDisappear{
            Stream.self.stopReceive(0)
        }
    }
    
}





struct streamView_Previews: PreviewProvider {
    static var previews: some View {
        streamView()
    }
}
