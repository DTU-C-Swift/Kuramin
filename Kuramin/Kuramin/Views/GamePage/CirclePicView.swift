//
//  GamePage_ProfileView.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import SwiftUI

struct CirclePicView: View {
    @ObservedObject var player: Player
    @ObservedObject var game: Game
    
    init(player: Player, game: Game) {
        self.player = player
        self.game = game
    }
    
    
    var body: some View {
        
        
        if !game.isGameStarted || (game.isGameStarted && !player.isLeft) {
            
            VStack(spacing: 1) {
                
                Image(uiImage: player.image)
                    .frame(width: 60, height: 60)
                    .scaleEffect(0.6)
                    .clipShape(Circle())
                    .overlay{
                        Circle().stroke(Color.white, lineWidth: 4)
                            .shadow(radius: 7)
                    }
                
                Text(player.displayName)
                    .font(.footnote)
                    .foregroundColor(Color.white)
                
            }
            
            
        } else {
            
            
            VStack(spacing: 1) {
                Image(uiImage: player.image)
                    .frame(width: 60, height: 60)
                    .scaleEffect(0.6)
                    .clipShape(Circle())
                    .overlay{
                        Circle().stroke(Color.white, lineWidth: 4)
                            .shadow(radius: 7)
                    }
                
                Text(player.displayName)
                    .font(.footnote)
            }
            .hidden()
            
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
}

struct CirclePicView_Previews: PreviewProvider {
    static var previews: some View {
        CirclePicView(player: DataHolder.controller.game.me, game: DataHolder.controller.game)
        
    }
}
