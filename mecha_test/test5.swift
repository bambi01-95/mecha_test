//
//  test5.swift
//  mecha_test
//
//  Created by Hiroto SHIKADA on 2023/06/18.
//

import SwiftUI

enum Pagetype{
    case home
    case NormalStick
    case NormalGyro
    case SpecialStick
    case SpecialGyro
}

// MARK: PAGE CONTROLLER
struct test5: View {
    @State var page:Pagetype = .home
    @State var home: Bool = true
    
    var body: some View {
        HStack{
            if home == true{
                if (page == .home){
                    Homepage(page:$page,home:$home)
                }
            }
            else{
                if(page == .NormalStick){
                    NormalStickView(page: $page, home: $home)
                }
                if(page == .NormalGyro){
                    NormalGyroView(page: $page, home: $home)
                }
                if(page == .SpecialStick){
                    SpecialStickView(page: $page, home: $home)
                }
                if(page == .SpecialGyro){
                    SpecialGyroView(page: $page, home: $home)
                }
            }
        }
    }
}
// MARK: HOME PAGE

struct Homepage: View{
    @Binding var page:Pagetype
    @Binding var home:Bool
    
    @State var StickON: Bool = true
    @State var monitorOn:Bool = false
    
    @State var curentIP:String = "123.12.34.56"
    @State var settingIP:String = ""
    @State var curentPort:String = "8080"
    @State var settingPort:String = ""
    @State var myIP:String = "123.12.34.56"
    @State var myPORT:String = "8080"
    
    @State var selectedNS: String = "Normal"
    @State var selectedSG: String = "Stick"
    
    var buttonHeight: CGFloat = 50
    var body: some View{
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
            HStack{
                // MARK: left
                
                VStack{
                    TextField("   IP: \(curentIP)",text:$settingIP)
                        .frame(width: 400)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numbersAndPunctuation)
                        .padding(.all,5)
                    TextField("Port: \(curentPort)",text:$settingPort)
                        .frame(width: 400)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.all,5)
                    
                    Text("     IP: \(myIP)")
                        .frame(width: 400,height: 35,alignment: .leading)
                        .background()
                        .cornerRadius(5)
                        .padding(.all,5)
                    
                    Text("  Port: \(myPORT)")
                        .frame(width: 400,height: 35,alignment: .leading)
                        .background()
                        .cornerRadius(5)
                        .padding(.all,5)
                    
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
                .frame(height: Sheight * 7 / 10)
                .padding(15)
                .background(Color(red: 0.8, green: 0.2, blue: 0.4, opacity: 0.2))
                .cornerRadius(15)
                
                
                
                // MARK: right
                VStack{
                    
                    Button {
                        monitorOn = false
                        selectedNS = "Normal"
                    } label: {
                        Text("Normal")
                            .bold()
                            .padding()
                            .frame(width: 200, height: buttonHeight)
                            .foregroundColor(Color.white)
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                    .shadow(radius:(monitorOn == false) ? 10 : 0)
                    .opacity((monitorOn == false) ? 1 : 0.4)
                    
                    Button {
                        monitorOn = true
                        selectedNS = "Special"
                    } label: {
                        Text("Special")
                            .bold()
                            .padding()
                            .frame(width: 200, height: buttonHeight)
                            .foregroundColor(Color.white)
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                    .shadow(radius:(monitorOn == true) ? 10 : 0)
                    .opacity((monitorOn == true) ? 1 : 0.4)
                    
                    HStack{
                        Button {
                            StickON = true
                            selectedSG = "Stick"
                        } label: {
//                            Text("Stick")
                            Image(systemName: "gamecontroller.fill")
                                .bold()
                                .padding()
                                .frame(width: 95, height: buttonHeight)
                                .foregroundColor(Color.white)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .shadow(radius:(StickON == true) ? 10 : 0)
                        .opacity((StickON == true) ? 1 : 0.4)
                        
                        Button {
                            StickON = false
                            selectedSG = "Gyro"
                        } label: {
                            Image(systemName:"steeringwheel")
                                .bold()
                                .padding()
                                .frame(width: 95, height: buttonHeight)
                                .foregroundColor(Color.white)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .shadow(radius:(StickON == false) ? 10 : 0)
                        .opacity((StickON == false) ? 1 : 0.4)
                    }
                    
                    Text("\(selectedNS) \(selectedSG) controller")
                        .bold()
                        .foregroundColor(Color.white)
                    
                    Button {
                        if(monitorOn == true){
                            if(StickON == true){
                                page = .SpecialStick
                                
                            }
                            else{
                                page = .SpecialGyro
                            }
                        }
                        else if(monitorOn == false){
                            if(StickON == true){
                                page = .NormalStick
                            }
                            else{
                                page = .NormalGyro
                            }
                        }
                    } label: {
                        Text("Start")
                            .bold()
                            .padding()
                            .frame(width: 200, height: buttonHeight)
                            .foregroundColor(Color.white)
                            .background(Color.purple)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                    }
                    
                }
                .frame(height: Sheight * 7 / 10)
                .padding(15)
                .background(Color(red: 0.8, green: 0.2, blue: 0.4, opacity: 0.2))
                .cornerRadius(15)
            }
            .onAppear{print("s-home")}
            .onDisappear{
                print("e-home")
                home = false
            }
        }
    }
}


// MARK: Controller View

struct NormalStickView: View {
    @Binding var page:Pagetype
    @Binding var home:Bool
    var body: some View {
        ZStack{
            Button {
                page = .home
            } label: {
                Image("home")
                    .resizable()
                    .frame(width: 70,height: 50)
            }
            .position(x:10,y:40)
            Text("normalstick").onAppear{print("s-NS")}.onDisappear{print("e-NS")}
        }
        .onDisappear{
            home = true
        }
    }
}
struct NormalGyroView: View {
    @Binding var page:Pagetype
    @Binding var home:Bool
    var body: some View {
        ZStack{
            Button {
                page = .home
            } label: {
                Image("home")
                    .resizable()
                    .frame(width: 70,height: 50)
            }
            .position(x:10,y:40)
            Text("normalgyro").onAppear{print("s-NG")}.onDisappear{print("e-NG")}
        }
        .onDisappear{
            home = true
        }
    }
}
struct SpecialStickView: View {
    @Binding var page:Pagetype
    @Binding var home:Bool
    var body: some View {
        ZStack{
            Button {
                page = .home
            } label: {
                Image("home")
                    .resizable()
                    .frame(width: 70,height: 50)
            }
            .position(x:10,y:40)
//            Text("specialstick").onAppear{print("s-SS")}.onDisappear{print("e-SS")}
            secondView()
        }
        .onDisappear{
            home = true
        }
    }
}
struct SpecialGyroView: View {
    @Binding var page:Pagetype
    @Binding var home:Bool
    var body: some View {
        ZStack{
            thirdhalf()
            Button {
                page = .home
            } label: {
                Image("home")
                    .resizable()
                    .frame(width: 70,height: 50)
            }
            .position(x:10,y:40)
//            Text("specialgyro").onAppear{print("s-SG")}.onDisappear{print("e-SG")}
        }
        .onDisappear{
            home = true
        }
    }
}


struct test5_Previews: PreviewProvider {
    static var previews: some View {
        test5()
    }
}
