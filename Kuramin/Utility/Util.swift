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
    
    func deleteEmptyIds(lobby: inout Lobby) {
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
}



