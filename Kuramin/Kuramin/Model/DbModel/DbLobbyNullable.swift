//
//  DbLobby.swift
//  Kuramin
//
//  Created by MD. Zahed on 17/03/2023.
//

import Foundation
import FirebaseFirestoreSwift



public struct DbLobbyNullable: Codable {
    var gameId: String?
    var hostId: String?
    var whoseTurn: String?
    var players: [DbPlayerNullable]?
    var cardOnBoard: String?
    
    
    
    
    
    
    func mapToLobby() -> Lobby? {
        
        var dbPlayers: [DbPlayer] = []
        
        if let dbPlayersNullable = self.players {
            
            for crr in dbPlayersNullable {
                
                let newDbP = crr.mapToDbPlayer()
                
                if let newDbP = newDbP {
                    
                    dbPlayers.append(newDbP)
                    
                }
                
            }
            
        }
        
        
        
        if let gameId = self.gameId, let host = self.hostId, let whosTurn = self.whoseTurn, let cardOnBoard = self.cardOnBoard {
            
            return Lobby(gameId: gameId, host: host, whosTurn: whosTurn, players: dbPlayers, cardOnBoard: cardOnBoard)
            
        } else {
            
            print("DbLobby: \(self.gameId ?? "" ) is nil")
        }
        
        
        return nil
    }
    
    
    
    
    
    
    
//    func isDuplicate(anotherDbLobbyNullable: DbLobbyNullable) {
//
//
//    }
}


public struct Lobby {
    var gameId: String
    var hostId: String
    var whosTurn: String
    var players: [DbPlayer]
    var cardOnBoard: String

    
    
    
    init(gameId: String, host: String, whosTurn: String, players: [DbPlayer], cardOnBoard: String
) {
        self.gameId = gameId
        self.hostId = host
        self.whosTurn = whosTurn
        self.players = players
        self.cardOnBoard = cardOnBoard
    }
    
    
    
        
    func getCardOnBoard() -> Card? {
        
        if cardOnBoard.isEmpty == true { return nil}
        
        
        var str = cardOnBoard
        // get the index of the 0th character
        let index = str.index(str.startIndex, offsetBy: 0)
        let suit = str.remove(at: index)
        
        //let suit = getElement(str: String(crrVal), index: 0)
        //let valueStr = getElement(str: String(crrVal), index: 1)
        
        let valueInt = Int(str)
        
        if valueInt != nil {
            return Card(suit: suit, value: valueInt!)
        }
        
        return nil
    }
    
    
//    func isDuplicateLobby(compareWith: Lobby) -> Bool {
//
//        if players.count != compareWith.players.count ||
//            hostId != compareWith.hostId {return false}
//
//
//        for (index, crrP) in players.enumerated()  {
//
//            if crrP.pid != compareWith.players[index].pid {
//
//                if !compareWith.players.contains(where: {$0.pid == crrP.pid}) {return false}
//
//            }
//
//        }
//
//
//        return true
//    }
    
}
