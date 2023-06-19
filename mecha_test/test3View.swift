//
//  test3View.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/17.
//

import SwiftUI
enum Pages{
    case page0
    case page1
    case page2
    case page3
    case page4}

struct test3View: View {

    @State var page:Pages = .page0
    @State var home: Bool = true
    
    var body: some View {
        HStack{
            if home == true{
                if page == .page0{
                    test0(page:$page,home:$home)
                }
            }
            else{
                if page == .page1{
                    test1(page:$page,home:$home)
                }
                
                if page == .page2{
                    test2(page:$page,home:$home)
                }
                
                if page == .page3{
                    test3(page:$page,home:$home)

                }
                if page == .page4{
                    test4(page:$page,home:$home)

                }
            }
        }
    }
}

struct test0: View{
    @Binding var page:Pages
    @Binding var home:Bool
    @State var curentIP:String = "123.12.34.56"
    @State var settingIP:String = ""
    @State var curentPort:String = "8080"
    @State var settingPort:String = ""
    @State var myIP:String = "123.12.34.56"
    @State var myPORT:String = "8080"
    var buttonHeight: CGFloat = 50
    var body: some View{
        HStack{
            // left
            
            VStack{
                TextField("   IP: \(curentIP)",text:$settingIP)
                    .frame(width: 400)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numbersAndPunctuation)
                TextField("Port: \(curentPort)",text:$settingPort)
                    .frame(width: 400)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numbersAndPunctuation)
                Text("     IP: \(myIP)")
                    .frame(width: 400,height: 35,alignment: .leading)
                    .background()
                    .cornerRadius(5)
                    
                Text("  Port: \(myPORT)")
                    .frame(width: 400,height: 35,alignment: .leading)
                    .background()
                    .cornerRadius(5)
                    
     
                
                
                Button {
                    if settingIP != ""{
                        curentIP = settingIP
                        settingIP = ""
                    }
                    if settingPort != ""{
                        curentPort = settingPort
                        settingPort = ""
                    }

                } label: {
                    Text("Set")
                        .bold()
                        .padding()
                        .frame(width: 200, height: buttonHeight)
                        .foregroundColor(Color.white)
                        .background(Color.purple)
                        .cornerRadius(100)
                }
                .shadow(radius: 5)
                
            }
            .padding(15)
            .background(Color(red: 0.8, green: 0.2, blue: 0.4, opacity: 0.2))
            .cornerRadius(15)
            
            
            // right
            VStack{
                
                Button {
                    page = .page1
                } label: {
                    Text("With PC")
                        .bold()
                        .padding()
                        .frame(width: 200, height: buttonHeight)
                        .foregroundColor(Color.white)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                
                Button {
                    page = .page2
                } label: {
                    Text("Only Phone")
                        .bold()
                        .padding()
                        .frame(width: 200, height: buttonHeight)
                        .foregroundColor(Color.white)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                HStack{
                    Button {
                        page = .page3
                    } label: {
                        Text("Stick")
                            .bold()
                            .padding()
                            .frame(width: 95, height: buttonHeight)
                            .foregroundColor(Color.white)
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        page = .page4
                    } label: {
                        Text("GYRO")
                            .bold()
                            .padding()
                            .frame(width: 95, height: buttonHeight)
                            .foregroundColor(Color.white)
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                }
                Button {
                    
                } label: {
                    Text("GYRO")
                        .bold()
                        .padding()
                        .frame(width: 200, height: buttonHeight)
                        .foregroundColor(Color.white)
                        .background(Color.purple)
                        .cornerRadius(10)
                }

            }
            .padding(15)
            .background(Color(red: 0.8, green: 0.2, blue: 0.4, opacity: 0.2))
            .cornerRadius(15)
        }
        
        .onAppear{print("s0")}
        .onDisappear{
            print("e0")
            home = false
        }
    }
}

struct test1: View {
    @Binding var page:Pages
    @Binding var home:Bool
    var body: some View {
        ZStack{
            Button {
                page = .page0
            } label: {
                Image("home")
                    .resizable()
                    .frame(width: 70,height: 50)
            }
            .position(x:40,y:40)
            VStack{
                Text("test1").onAppear{print("s1")}.onDisappear{print("e1")}
                Button {
                    print("nononon")
                } label: {
                    Image("home")
                        .resizable()
                        .frame(width: 70,height: 50)
                }
            }
        }
        .onDisappear{
            home = true
        }
    }
}


struct test2: View {
    @Binding var page:Pages
    @Binding var home:Bool
    var body: some View {
        ZStack{
            Button {
                page = .page0
            } label: {
                Image("home")
                    .resizable()
                    .frame(width: 70,height: 50)
            }
            .position(x:40,y:40)
            Text("test2").onAppear{print("s2")}.onDisappear{print("e2")}
        }
        .onDisappear{
            home = true
        }
    }
    
}

struct test3: View {
    @Binding var page:Pages
    @Binding var home:Bool
    var body: some View {
        ZStack{
            Button {
                page = .page0
            } label: {
                Image("home")
                    .resizable()
                    .frame(width: 70,height: 50)
            }
            .position(x:40,y:40)
            Text("test3").onAppear{print("s3")}.onDisappear{print("e3")}
        }
        .onDisappear{
            home = true
        }
    }
}
struct test4: View {
    @Binding var page:Pages
    @Binding var home:Bool
    var body: some View {
        ZStack{
            Button {
                page = .page0
            } label: {
                Image("home")
                    .resizable()
                    .frame(width: 70,height: 50)
            }
            .position(x:40,y:40)
            Text("test4").onAppear{print("s4")}.onDisappear{print("e4")}
        }
        .onDisappear{
            home = true
        }
    }
}

struct test3View_Previews: PreviewProvider {
    static var previews: some View {
        test3View()
    }
}
