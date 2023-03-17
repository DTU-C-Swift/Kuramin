//
//  Printer.swift
//  Kuramin
//
//  Created by MD. Zahed on 09/03/2023.
//

import Foundation
import SwiftUI



struct Util {
    let PROGRESSING = "display"
    let SUCCEDED = "succeded"
    let FAILED = "failed"
    let MY_DUMMY_ID = "myId"
    let NOT_SET = "notSet"
    
    
    
    
    
    
    
    func convertDbuserToPlayer(dbUser: DbUser, player: Player) {
        if dbUser.uid == nil {
            print("Util: dbuser id is nill")
        }
       player.lock.lock()
        
        player.id = dbUser.uid ?? MY_DUMMY_ID
        player.fullName = dbUser.fullName
        player.coins = dbUser.coins
        
        player.setDisplayName()
        
        player.lock.unlock()
    }
    
    func deleteEmptyIds(lobby: inout FirstLobby) {
        var idsToBeDeleted: [Int] = []
        
        for (idIndex, id) in lobby.playerIds.enumerated() {
            
            if id == DataHolder.controller.game.me.id ||
                id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                
                idsToBeDeleted.append(idIndex)
            }
        }
        
        
        
        lobby.playerIds.remove(atOffsets: IndexSet(idsToBeDeleted))
        lobby.removeDuplicates()
    }
    
    
    func isDuplicateLobby(lobby1: FirstLobby, lobby2: FirstLobby) -> Bool {
        
        if lobby1.playerIds.count != lobby2.playerIds.count ||
            lobby1.host != lobby2.host {return false}

        
        if lobby1.playerIds != lobby2.playerIds {
            return false
        }
        
        return true
    }
    
    
    

    

}



