//
//  DbPlayer.swift
//  Kuramin
//
//  Created by MD. Zahed on 16/03/2023.
//

import Foundation
import FirebaseFirestoreSwift


public struct DbPlayerNullable: Codable {
    var pName: String?
    var pid: String?
    var randomNum: Int?
    var cards: String?
    var cardsInHand: Int?
    
    
    
    func mapToDbPlayer() -> DbPlayer? {
                
        if let pName = self.pName, let pid = self.pid, let randomNum = self.randomNum,
           let cards = self.cards, let cardsInHand = self.cardsInHand {
            
            if pid.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                return nil
            }
            
    
            return DbPlayer(pName: pName, pid: pid, randomNum: randomNum, cards: cards, cardsInHand: cardsInHand)
            
        }
        
        print("DbPlayerNullable: player \(self.pid!) is nil")
        return nil
    }
    
    
    func toDictionary() -> [String: Any] {
        return [
            "pName": pName ?? Util.NOT_SET,
            "pid": pid ?? Util.NOT_SET,
            "randomNum": randomNum ?? Util.NOTSET_INT,
            "cards": cards ?? "",
            "cardsInHand": cardsInHand ?? Util.NOTSET_INT

        ]
    }
    
}




public struct DbPlayer {
    var pName: String
    var pid: String
    var randomNum: Int
    var cards: String
    var cardsInHand: Int
    

    
    
    func createPlayer() -> Player {
        let cards = mapToCards()
        let player = Player(id: pid, fullName: pName, image: nil, isLeft: false,
                      coins: nil, cardsInHand: cardsInHand, randomNum: randomNum)
        
        for crrCard in cards {
            player.addCard(card: crrCard)
        }

        return player
    }
    
    
    
    
    func mapToCards() -> [Card] {
        
        let val = cards.split(separator: " ")

        var cards: [Card] = []
        
        for crrVal in val {
            
            
            var str = crrVal
            // get the index of the 7th character ("w")
            let index = str.index(str.startIndex, offsetBy: 0)
            let suit = str.remove(at: index)
            
            //let suit = getElement(str: String(crrVal), index: 0)
            //let valueStr = getElement(str: String(crrVal), index: 1)
            
            let valueInt = Int(str)
            
            if valueInt != nil {
                let newCard = Card(suit: suit, value: valueInt!)
                cards.append(newCard)
                
            }

        }
        
        return cards
        
        
    }
    
    
    func getElement(str: String, index: Int) -> String? {
        if let secondCharIndex = str.index(str.startIndex, offsetBy: index, limitedBy: str.endIndex) {
            return String(str[secondCharIndex])
        } else {
            print("Invalid input")
            return nil
        }
    }
}

