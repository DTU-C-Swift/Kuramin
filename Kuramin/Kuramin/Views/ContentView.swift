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
    
    @State var email: String = ""
    @State var password: String = ""
    
    init() {
        controller = DataHolder.controller
        //controller.listenForLogout()

    }
    var body: some View {
        
        NavigationView {
            
            ZStack {
                VStack {
                    HStack {
                        Image(systemName: "mail")
                        TextField("Email", text: $email)
                        Spacer()
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black)
                    )
                    .padding(.vertical, 2)
                    .padding(.horizontal, 200)
                    
                    HStack {
                        Image(systemName: "lock")
                        TextField("Password", text: $password)
                        Spacer()
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black)
                    )
                    .padding(.vertical, 2)
                    .padding(.horizontal, 200)
                    
                    Button(action: pass) {
                        Text("Sign In")
                    }
                    
                    HStack {
                        NavigationLink(destination: MainPage()) {
                            HStack {
                                Image(systemName: "applelogo")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Color.black)
                            .cornerRadius(16)
                            .shadow(radius: 4, x: 0, y: 4)
                        }
                        FbAuth(width: 210, height: 50)
                            .cornerRadius(16)
                            .shadow(radius: 4, x: 0, y: 4)
                        
                        NavigationLink(destination: MainPage()) {
                            HStack {
                                Image(systemName: "tree")
                                    .font(.system(size: 24))
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(radius: 4, x: 0, y: 4)
                        }
                        
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
                controller.service.observeMeInDB()
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
