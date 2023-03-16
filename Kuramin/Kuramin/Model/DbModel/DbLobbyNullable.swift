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
    var host: String?
    var whosTurn: String?
    var players: [DbPlayerNullable]?
    
    
    
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
        
        
        
        
        
        if let gameId = self.gameId, let host = self.host, let whosTurn = self.whosTurn {
            
            return Lobby(gameId: gameId, host: host, whosTurn: whosTurn, players: dbPlayers)
            
        } else {
            
            print("DbLobby: \(self.gameId!) is nil")
        }
        
        
        return nil
    }
}


public struct Lobby {
    var gameId: String
    var host: String
    var whosTurn: String
    var players: [DbPlayer]
    
}
