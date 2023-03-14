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
    @Published var me: Player = Player(id: Util().MY_DUMMY_ID)
    var hostId: Player = Player(id: "hostId")
    
    let p = Printer(tag: "Game", displayPrints: true)
    
    init() {
        //self.addDummyPlayers()

    }
    
    

    
    

    
    
    
    func updatePlayerList(lobby: Lobby) {
        var toBeDeleted: [Int] = []
        
        for (index, p) in players.enumerated() {
            
            if !lobby.playerIds.contains(p.id) {
                toBeDeleted.append(index)
            }
        }
        
        for index in toBeDeleted {
            players.remove(at: index)
        }
        
        self.p.write("Player list has been updated")
    }
    
    
    
    
    
    func addPlayer(player: Player) {
        if player.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return }

        
        for (index, p) in players.enumerated() {
            
            if p.id == player.id {
                // Update
                p.update(player: player)
                return
            }
        }
        
        players.append(player)
    }
    
    
    
    func setPlayerImg(pid: String, image: UIImage) {
        
        if me.id == pid {
            me.image = image
            return
        }
        
        for p in players {
            if p.id == pid {
                p.image = image
            }
        }
        
        self.p.write("PlayerId: \(pid) not found")
        
    }
    
    
    
    
    
    
    func addDummyPlayers() {
        
        for i in 1...8 {
            let newPlayer = Player(id: "id\(i)")
            newPlayer.id = UUID().uuidString
            newPlayer.displayName = "player" + String(i)
            if i <= 7 {
                newPlayer.isNotDummy = true
            }
            players.append(newPlayer)
        }
        
        
    }

}


