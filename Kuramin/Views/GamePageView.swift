//
//  GamePageView.swift
//  Kuramin
//
//  Created by Numan Bashir on 16/02/2023.
//

import SwiftUI

struct GamePageView: View {
    @State private var isAnimating = false
    
    var playerName1 = "Player1"
    var playerName2 = "Player2"
    var playerName3 = "Player3"
    var playerName4 = "Player4"
    var imageName = "person_34"
    
    @EnvironmentObject var controller: Controller
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.cyan, Color.blue, Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: .trailing)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 150)
                .strokeBorder(Color.cyan, lineWidth: 35)
                .scaleEffect(0.68)
                .padding(.top, 30)
            RoundedRectangle(cornerRadius: 150)
                .strokeBorder(Color.black, lineWidth: 30)
                .scaleEffect(0.7)
                .shadow(color: Color.cyan, radius: 10, x: 0, y: 5)
                .padding(.top, 30)

            
            VStack {
                
                HStack() {
                    Spacer()
                    
                    CirclePicView(playerName: playerName1, imageName: imageName)
                        .padding(.top, 3)
                    
                    Spacer()
                    
                }
                
                
                Spacer()
                HStack() {
                    
                    CirclePicView(playerName: playerName2, imageName: imageName)
                    Spacer()
                    
                    CirclePicView(playerName: playerName3, imageName: imageName)
                    
                }
                
                
                
                Spacer()
                
                
                HStack() {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(Color.cyan)
                            .frame(width: 300, height: 40)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 0.5)
                            )
                        
                            .shadow(radius: 20)
                        
                        CirclePicView(playerName: "", imageName: imageName)
                        
                    }
                    Spacer()
                }
                
                
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
        
        
    }
    
    
}



struct GamePageView_Previews: PreviewProvider {
    static var previews: some View {
        GamePageView()
        
        
    }
}
