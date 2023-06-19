//
//  LaunchScreen.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/02.
//
//https://qiita.com/uhooi/items/ce31c80b7f5035e20be7
// アプリ起動時の画面　スプラッシュスクリーン

import SwiftUI
struct LaunchScreen: View {
    @State private var isLoading = true
    var body: some View {
        ZStack{
            if isLoading {
                ZStack {
                    VStack{
                        Image("logo_tata2")
                            .resizable()
                            .frame(width: 400,height: 200)
                        ProgressAnimation()
                    }
                }
                .onAppear {//↓ページ変わるまでの時間
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isLoading = false
                        }
                    }
                }
            } else {
                ContentView()//スプラッシュスクリーン後に開くページ
            }
        }
    }
}


// https://cindori.com/developer/swiftui-animation-loading
// Progress animation
struct ProgressAnimation: View {
    @State private var drawingWidth = false
 
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(.systemGray6))
                RoundedRectangle(cornerRadius: 3)
                    .fill(.indigo.gradient)
                    .frame(width: drawingWidth ? 250 : 0, alignment: .leading)
                    .animation(.easeInOut(duration: 2.3).repeatForever(autoreverses: false), value: drawingWidth)//duration: animationの時間
            }
            .frame(width: 250, height: 12)
            .onAppear {
                drawingWidth.toggle()
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
