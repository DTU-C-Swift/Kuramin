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
    
    //@EnvironmentObject var controller: Controller
    var controller: Controller
    
    init() {
        self.controller = DataHolder.controller
        controller.game.addDummyPlayers()
  
    }
    
    
    var body: some View {
        
        ZStack {
            
            
            BackgroundView()
            
            VStack {
                
                HStack() {
                    Spacer()
                    
                    CirclePicView(player: controller.game.players[0])
                        .padding(.top, 3)
                    
                    Spacer()
                    
                }
                
                
                Spacer()
                HStack() {
                    
                    CirclePicView(player: controller.game.players[1])
                    Spacer()
                    
                    CirclePicView(player: controller.game.players[2])
                    Text(controller.game.player.name).foregroundColor(.white)
                    
                }
                
                
                
                Spacer()
                
                
                HStack() {
                    
                    Button(action: {
                        controller.game.player.name = "New Name"
                        
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                    }
                    
                    
                    
                    
                    
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
                        
                        CirclePicView(player: controller.game.player)
                        
                    }
                    Spacer()
                }
                
                
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            controller.game.addDummyPlayers()
//        }
        
        
    }
    
    
}



struct GamePageView_Previews: PreviewProvider {
    static var previews: some View {
        GamePageView()
        
        
    }
}
