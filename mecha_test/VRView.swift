//
//  VRView.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/15.
//

import SwiftUI

struct VRView: View {
    @ObservedObject var Stream = streamFrames()
    var body: some View {
        ZStack{
            VStack{
                if let uiImage = UIImage(data: Stream.img_data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 600, height: 300)
                        .border(.black, width: 2)
                        .padding(.top,20)
                }
                else{
                    Image("back_gray")
                        .resizable()
                        .frame(width: 760, height: 380)
                        .border(.black, width: 2)
                        .padding(.top,20)
                }
            }
        }
        .onAppear{
            Stream.self.startReceive(0)
        }
        .onDisappear{
            Stream.self.stopReceive(0)
        }
    }
}

struct VRView_Previews: PreviewProvider {
    static var previews: some View {
        VRView()
    }
}
