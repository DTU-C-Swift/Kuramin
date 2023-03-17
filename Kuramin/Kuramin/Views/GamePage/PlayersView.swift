//
//  PlayersView.swift
//  Kuramin
//
//  Created by MD. Zahed on 17/03/2023.
//

import SwiftUI


struct PlayersView: View {
    //@Binding var game: Game
    
    @ObservedObject var game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    
    
    
    
    
    var body: some View {
        
        switch game.players.count {
            
        case 1:
            ZStack {
                
                
                HStack() {
                    Spacer()
                    if game.players.count > 0 {
                        CirclePicView(player: game.players[0], game: game)
                    }
                    
                    if game.players.count > 3 {
                        Spacer()
                        CirclePicView(player: game.players[3], game: game)
                    }
                    
                    
                    if game.players.count > 4 {
                        Spacer()
                        CirclePicView(player: game.players[4], game: game)
                    }
                    
                    Spacer()
                    
                    
                }
                .padding(.top, 4)
                
                
                
                
            }
            
        case 2:
            ZStack {
                
            }
            
            
        case 3:
            ZStack {
                
            }
            
        case 4:
            ZStack {
                
            }
            
        case 5:
            ZStack {
                
            }
            
        case 6:
            ZStack {
                
            }
            
        case 7:
            ZStack {
                
            }
            
            
        default:
            Text("NOT POSSIBLE")
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        VStack {
            
            HStack() {
                Spacer()
                if game.players.count > 0 {
                    CirclePicView(player: game.players[0], game: game)
                }
                
                if game.players.count > 3 {
                    Spacer()
                    CirclePicView(player: game.players[3], game: game)
                }
                
                
                if game.players.count > 4 {
                    Spacer()
                    CirclePicView(player: game.players[4], game: game)
                }
                
                Spacer()
                
                
            }
            .padding(.top, 4)
            
                        
            Spacer()
            HStack() {
                
                VStack{
                    
                    Spacer()
                    
                    if game.players.count > 5 {
                        CirclePicView(player: game.players[5], game: game)
                        Spacer()
                    }
                    
                    if game.players.count > 1 {
                        CirclePicView(player: game.players[1], game: game)
                    }
                    
                    Spacer()
                    
                }
                
                
                Spacer()
                VStack {
                    Spacer()
                    if game.players.count > 6 {
                        CirclePicView(player: game.players[6], game: game)
                        Spacer()
                    }
                    
                    if game.players.count > 2 {
                        CirclePicView(player: game.players[2], game: game)
                    }
                    
                    Spacer()
                }
                
            }
            
            
            Spacer()
            

        }
        
        
    }
}

struct PlayersView_Previews: PreviewProvider {
    //@ObservedObject var game = DataHolder.controller.game
    
    static var previews: some View {
        PlayersView(game: DataHolder.controller.game)
    }
}
