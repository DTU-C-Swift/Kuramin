//
//  Deck.swift
//  Kuramin
//
//  Created by MD. Zahed on 24/03/2023.
//

import Foundation

class Deck {
    
    var cards: [Card] = []
    let amountOfInitCards = 8
    
    
    
    init() {
        initalizeDeck()
    }
    
    
    func initalizeDeck() {
        createCardDeck()
        createCardDeck()
        cards.shuffle()
        cards.shuffle()
        
    }
    
    
    private func createCardDeck() {
        
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
            
            for i in 0..<amountOfInitCards {
                
                str += "\(cards.popLast()!.toString())"
                if i < amountOfInitCards-1  {str += " "}
            }
            
            dbLobby.players![index].cards = str
        }
        
    }
    
}
