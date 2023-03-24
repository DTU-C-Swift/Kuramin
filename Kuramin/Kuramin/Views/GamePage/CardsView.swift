//
//  CardsView.swift
//  Kuramin
//
//  Created by MD. Zahed on 24/03/2023.
//

import SwiftUI

struct CardsView: View {
    
    @ObservedObject var me: Player
    //var degress: Double
    
    init(me: Player) {
        self.me = me
        me.addCard(card: Card(suit: "H", value: 10))
        me.addCard(card: Card(suit: "D", value: 10))
        me.addCard(card: Card(suit: "S", value: 10))
        me.addCard(card: Card(suit: "C", value: 10))

        //self.degress = 80.0 / Double(me.cards.count)

    }
    
    
    var body: some View {
        
//        HStack {
//            ForEach(me.cards.indices) { index in
//                CardView(card: me.cards[index])
//            }
//        }
        
        
        HStack {
            
            CardView(card: me.cards[0])
            CardView(card: me.cards[1])
            CardView(card: me.cards[3])

        }
        
        
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        CardsView(me: DataHolder.controller.game.me)
    }
}
