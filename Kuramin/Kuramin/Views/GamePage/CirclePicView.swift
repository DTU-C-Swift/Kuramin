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
    let progressTime = 20
    
    init(player: Player, game: Game) {
        self.player = player
        self.game = game
    }
    
    @State private var opacity: Double = 0.5

    
    var body: some View {
        
        

        ZStack(alignment: .top) {
            
            
            Image(uiImage: player.image)
                .frame(width: 60, height: 60)
                .scaleEffect(0.6)
                .clipShape(Circle())
                .overlay{
                    Circle().stroke(Color.white, lineWidth: 4)
                        .shadow(radius: 7)
                }
            
            
                    
            
            if game.playerTurnId == player.id {
                Circle()
                    .stroke(
                        Color.green.opacity(0.5),
                        lineWidth: 8
                    )
                    .frame(width: 60, height: 60)
                
                
                TimerProgressBar(progressTime: progressTime)
                    .frame(width: 60, height: 60)
                
                    
            } else {
                
                
                Circle()
                    .stroke(
                        Color.red.opacity(0.5),
                        lineWidth: 8
                    )
                    .frame(width: 60, height: 60)
            }

            
            
            
            
            
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    Text(player.displayName)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                }
                .frame(width: 90, height: 20)
                Spacer()
            }



            
            
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    Text("\(player.cards.count)")
                        .font(.system(size: 12, weight: .bold))
                        .font(.footnote)
                        .foregroundColor(.black)
                }
                .frame(width: 25, height: 20)
            }
            
            
            
        }
        
        .frame(width: 90, height: 80)

    }
    
    
    
    
    
    
    
    
    
    
    
}

struct CirclePicView_Previews: PreviewProvider {
    static var previews: some View {
        CirclePicView(player: DataHolder.controller.game.me, game: DataHolder.controller.game)
        
    }
}
