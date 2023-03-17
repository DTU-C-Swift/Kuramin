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
    var whoseTurn: String?
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
        
        
        
        if let gameId = self.gameId, let host = self.host, let whosTurn = self.whoseTurn {
            
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
    
    
//    init(dbLobbyNullable arg: DbLobbyNullable) {
//
//
//
//        var dbPlayers: [DbPlayer] = []
//
//        if let dbPlayersNullable = arg.players {
//
//            for crr in dbPlayersNullable {
//
//                let newDbP = crr.mapToDbPlayer()
//
//                if let newDbP = newDbP {
//                    dbPlayers.append(newDbP)
//
//                }
//
//            }
//
//        }
//
//
//
//        if let gameId = arg.gameId, let host = arg.host, let whosTurn = arg.whoseTurn {
//
//            self.init(gameId: gameId, host: host, whosTurn: whosTurn, players: dbPlayers)
//
//        } else {
//
//
//            print("DbLobby: \(arg.gameId!) is nil")
//        }
//
//
//    }
    
    
    
    init(gameId: String, host: String, whosTurn: String, players: [DbPlayer]) {
        self.gameId = gameId
        self.host = host
        self.whosTurn = whosTurn
        self.players = players
    }
    
    
    
    
    
    
    
    
    func isDuplicateLobby(compareWith: Lobby) -> Bool {
        
        if players.count != compareWith.players.count ||
            host != compareWith.host {return false}

        
        for (index, crrP) in players.enumerated()  {
            
            if crrP.pid != compareWith.players[index].pid {
                
                if !compareWith.players.contains(where: {$0.pid == crrP.pid}) {return false}
                
            }
            
        }
        
        
        return true
    }
}
