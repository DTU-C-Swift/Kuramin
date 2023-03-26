//
//  CardView.swift
//  Kuramin
//
//  Created by MD. Zahed on 12/03/2023.
//

import SwiftUI

struct CardView: View {
    let controller = DataHolder.controller
    var card: Card
    var cardIndex: Int
    let width = 60.0
    let height = 130.0
    
    init(card: Card, cardIndex: Int) {
        self.card = card
        self.cardIndex = cardIndex
    }
    
    
    var body: some View {
        
        HStack {
            Button(action: {
                
                if controller.game.isMyTurn {
                    controller.send_card_to_next_player(cardIndex: cardIndex)
                } else {
                    Text("It now your turn")
                }
                
                
            }) {
                
                Image(card.toString())
                    .resizable()
                    .scaledToFit()
                    .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
                
            }
        }
        
        .background(.clear)
        .frame(width: width, height: height)
        
        
        
        
    }
    
    
    
    
    //    var body: some View {
    //        HStack {
    //            Image(card.toString())
    //                .resizable()
    //                .scaledToFit()
    //                .scaleEffect(0.3)
    //                .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
    //        }
    //
    //    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(suit: "H", value: 11), cardIndex: 0)
    }
}
