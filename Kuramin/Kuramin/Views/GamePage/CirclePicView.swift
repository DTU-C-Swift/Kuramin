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
        
        

        ZStack(alignment: .top) {
            
            Image(uiImage: player.image)
                .frame(width: 60, height: 60)
                .scaleEffect(0.6)
                .clipShape(Circle())
                .overlay{
                    Circle().stroke(Color.white, lineWidth: 4)
                        .shadow(radius: 7)
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
                Text("\(player.cardsInHand)")
                    .font(.system(size: 18, weight: .bold))
                    .font(.footnote)
                    .padding(0)
                    .background(.white)
                    .cornerRadius(5)
                    .foregroundColor(.black)
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
