//
//  Deck.swift
//  Kuramin
//
//  Created by MD. Zahed on 24/03/2023.
//

import Foundation

class Deck {
    
    var cards: [Card] = []
    
    init() {
        setCards()
        setCards()
        cards.shuffle()
        cards.shuffle()
    }
    
    
    func setCards() {
        
        for i in 1...13 {
            let newCard = Card(suit: "H", value: i)
            cards.append(newCard)
        }
        
        
        for i in 1...13 {
            let newCard = Card(suit: "D", value: i)
            cards.append(newCard)
        }
        
        for i in 1...13 {
            let newCard = Card(suit: "S", value: i)
            cards.append(newCard)
        }
        
        for i in 1...13 {
            let newCard = Card(suit: "C", value: i)
            cards.append(newCard)
        }
        
        
    }
    
    
    
    
    
    func setIntialCardToLobby(dbLobby: inout DbLobbyNullable) {
        if dbLobby.players == nil {return}
        
        for (index, _) in dbLobby.players!.enumerated() {
            
            
            var str = ""
            
            for i in 0...3 {
                
                str += "\(cards.popLast()!.toString())"
                if i < 3 {str += " "}
            }
            
            dbLobby.players![index].cards = str
        }
        
    }
    
}
