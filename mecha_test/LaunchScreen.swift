//
//  LaunchScreen.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/02.
//
//https://qiita.com/uhooi/items/ce31c80b7f5035e20be7
import SwiftUI
struct LaunchScreen: View {
    @State private var isLoading = true

    var body: some View {
        ZStack{
            if isLoading {
                ZStack {
                    VStack{
                        Image("logo_tata")
                            .resizable()
                            .frame(width: 400,height: 200)
                        ProgressAnimation()
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isLoading = false
                        }
                    }
                }
            } else {
                ContentView()
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
                    .animation(.easeInOut(duration: 2.3).repeatForever(autoreverses: false), value: drawingWidth)
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
