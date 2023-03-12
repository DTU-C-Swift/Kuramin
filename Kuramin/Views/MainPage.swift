//
//  MainPage.swift
//  Kuramin
//
//  Created by Numan Bashir on 09/03/2023.
//

import SwiftUI

struct MainPage: View {
    
    @State private var showMenu = false
    @State private var showProfile = false
    @State private var showHowTo = false
    @State private var showGamePage = false

    @ObservedObject var controller: Controller = DataHolder.controller
    @EnvironmentObject var navState: NavState
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    showProfile = true
                }, label: {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                })
                
                Button(action: {
                    showMenu = true
                }, label: {
                    Image(systemName: "gearshape.circle.fill")
                        .font(.system(size: 50))
                })

                
            }.padding(.top, 10)
            Spacer()
            
            Button(action: {
                showGamePage = true
            }, label: {
                Text("Start New Game")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 4, x: 0, y: 4)
                
            })
            
            
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
            
            Button("How To Play") {
                
            }
            
            
            
            
            Spacer()
        
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showMenu) {
            MenuPopup()
        }
        .sheet(isPresented: $showProfile) {
            ProfilePageView()
        }
        .sheet(isPresented: $showGamePage) {
            GamePage()
        }
        
        //
        
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}

