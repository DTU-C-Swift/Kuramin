//
//  ContentView.swift
//  Kuramin
//
//  Created by Numan Bashir on 16/02/2023.
//

import SwiftUI
import Firebase


struct ContentView: View {
    @ObservedObject var controller: Controller
    @State var navigateToMainPage = false
    
    init() {
        controller = DataHolder.controller

    }
    var body: some View {
        
        NavigationView {
            VStack {
                NavigationLink(destination: MainPageView()) {
                    HStack {
                        Image(systemName: "applelogo")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        Text("Login with Apple")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(Color.black)
                    .cornerRadius(16)
                    .shadow(radius: 4, x: 0, y: 4)
                }
                
                FbAuth(width: 257, height: 50)
                    .background(Color.blue)
                    .cornerRadius(16)
                    .shadow(radius: 4, x: 0, y: 4)
                    

                
                NavigationLink(destination: MainPageView()) {
                    HStack {
                        Image(systemName: "tree")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                        Text("Login with Google")
                            .font(.system(size: 24, weight:
                                    .semibold))
                                    .foregroundColor(.black)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 4, x: 0, y: 4)
                }
                
            }
            .padding()
        }
        .navigationTitle("Login")
        
        .onChange(of: controller.isLoggedIn) { newValue in
            if newValue == true {
                print("Navigate to main page")
                navigateToMainPage = true
            }
            else{
                print("Login with facebook failed")
            }
        }
        .sheet(isPresented: $navigateToMainPage) {
            MainPageView()
        }
        .onAppear() {
            print("on appearing")
            if Auth.auth().currentUser?.uid != nil {
                print("Is not nill")
                navigateToMainPage = true
            }
            
        }
  
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//
//    }
//}

struct MainPageView: View {
    @State var showMenu = false
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
    
                    showMenu = true
                }, label: {
                    Image(systemName: "gearshape.circle.fill")
                        .font(.system(size: 40))
                    
                })

                
            }.padding(.top, 10)
            Spacer()
            
            NavigationLink(destination: GamePage()) {
                Text("Start New Game")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 4, x: 0, y: 4)
            }
            
            
            
            Text("Join Game")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 4, x: 0, y: 4)
            
            Text("How To Play?")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 4, x: 0, y: 4)
            
            
            Spacer()
        
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showMenu) {
            MenuPopup()
        }
        
        //
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
        
    }
}
