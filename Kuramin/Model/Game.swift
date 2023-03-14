//
//  Game.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import Foundation
import SwiftUI

class Game : ObservableObject {
    var id: String = ""
    @Published var players: [Player] = []
    @Published var me: Player = Player()
    var host: Player = Player()
    
    let p = Printer(tag: "Game", displayPrints: true)
    
    init() {
        me.isNotDummy = true
    }
    
    
    func addDummyPlayers() {
        
        for i in 1...8 {
            let newPlayer = Player()
            newPlayer.id = UUID().uuidString
            newPlayer.displayName = "player" + String(i)
            if i <= 7 {
                newPlayer.isNotDummy = true
            }
            players.append(newPlayer)
        }
        
        
    }
    
    
    func getPlayerObj(_ id: String) -> Player? {
  // {$0.id == player.id} is the same as { player in player.id == player id }
        
        for p in players {
            if p.id == id {
                return p
                
            }
        }
        
        for p in players {
            if !p.isNotDummy {
                p.id = id
                return p
            }
        }
        
        
        
        self.p.write("Player with id \(id) not found")
        return nil
        
    }
    
    
    
    func updatePlayerList(lobby: Lobby) {
        
        for p in players {
            if !lobby.playerIds.contains(p.id) {
                p.isNotDummy = false
            }
        }
        
        

        self.p.write("Player list has been updated")
    }
    
    private func addPlayer(player: Player) {
        
    }
    

}


