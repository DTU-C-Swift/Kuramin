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
    }
    
    
    var body: some View {
        
        HStack(spacing: -10) {
            
            
            if me.cards.count > 0 {
                CardView(card: me.cards[0], cardIndex: 0)
            }
            
            
            if me.cards.count > 1 {
                CardView(card: me.cards[1], cardIndex: 1)
            }
            
            
            if me.cards.count > 2 {
                CardView(card: me.cards[2], cardIndex: 2)
            }
            
            
            if me.cards.count > 3 {
                CardView(card: me.cards[3], cardIndex: 3)
            }
            
            
            if me.cards.count > 4 {
                CardView(card: me.cards[4], cardIndex: 4)
            }
            
            
            if me.cards.count > 5 {
                CardView(card: me.cards[5], cardIndex: 5)
            }
            
            if me.cards.count > 6 {
                CardView(card: me.cards[6], cardIndex: 6)
            }
            
            
            if me.cards.count > 7 {
                CardView(card: me.cards[7], cardIndex: 7)
            }
            
            
            if me.cards.count > 8 {
                CardView(card: me.cards[8], cardIndex: 8)
            }
            
        }
        
    }
    
    
    func dummyCards() {
        
        me.addCard(card: Card(suit: "H", value: 10))
        me.addCard(card: Card(suit: "D", value: 10))
        me.addCard(card: Card(suit: "S", value: 10))
        me.addCard(card: Card(suit: "C", value: 10))
        
        me.addCard(card: Card(suit: "H", value: 10))
        me.addCard(card: Card(suit: "D", value: 10))
        me.addCard(card: Card(suit: "S", value: 10))
        me.addCard(card: Card(suit: "C", value: 10))
    }
    
    
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        CardsView(me: DataHolder.controller.game.me)
    }
}
