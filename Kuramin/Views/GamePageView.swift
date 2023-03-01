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
            
            BackgroundView()
            
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
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
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
