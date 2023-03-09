//
//  MainPage.swift
//  Kuramin
//
//  Created by Numan Bashir on 09/03/2023.
//

import SwiftUI

struct MainPage: View {
    
    @State private var showMenu = false
    @ObservedObject var controller: Controller = DataHolder.controller
    @EnvironmentObject var navState: NavState
    
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

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
