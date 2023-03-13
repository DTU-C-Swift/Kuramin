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
    @State var selection: String? = "NON"
    @State var showAlert = false
    @ObservedObject var navSate: NavState = NavState()
    
    init() {
        controller = DataHolder.controller
        //controller.listenForLogout()

    }
    var body: some View {
        
        NavigationView {
            
            ZStack {
                VStack {
                    NavigationLink(destination: MainPage()) {
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
                        .cornerRadius(16)
                        .shadow(radius: 4, x: 0, y: 4)
                        
                        
                    
                        
                    NavigationLink(destination: MainPage()) {
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
                    
                    
                    NavigationLink(destination: MainPage(), tag: "MainPageView", selection: $navSate.state){}
                    
                    
                    
                }
                .padding()
                .alert("There was an error. Please try again", isPresented: $showAlert) {
                            Button("OK", role: .cancel) { }
                        }
                
                
                if controller.bufferState == Util().PROGRESSING {
                    ProgressBar()

                }
                
                
            }
        }
        .navigationTitle("Login")
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(navSate)
        .onChange(of: controller.isLoggedIn) { newValue in
            if newValue == true {
                print("Navigate to main page")
                navigateToMainPage = true
                //selection = "MainPageView"
                controller.service.observeForUserChanges(player: controller.game.me)
                navSate.state = "MainPageView"
            }
            else{
                print("Login with facebook failed")
            }
        }

        .onChange(of: controller.bufferState) { newValue in
            if newValue == Util().FAILED {
                showAlert = true

            }
        }
        

        
  
    }
}


class NavState: ObservableObject {
    @Published var state: String? = nil
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()

    }
}





//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainPageView()
//
//    }
//}


//
