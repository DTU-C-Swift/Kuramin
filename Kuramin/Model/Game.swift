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
    @Published var playerListChanged: Bool = true

    var hostId = ""
    //private let lock = NSLock()
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
        if player.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.p.write("AddPlayer: playerId is empty. Id: \(player.id)")
            return }

        
        for (index, p) in players.enumerated() {
            
            if p.id == player.id {
                p.update(player: player)
                return
            }
        }
        
        players.append(player)
    }
    
    
    
    func addPlayer(dbUser: DbUser) {
        if dbUser.uid?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == nil {
            self.p.write("AddPlayer: playerId is empty. Id: \(dbUser.uid)")
            return
        }
        
        
        for p in self.players {
            if p.id == dbUser.uid {
                p.update(dbUser)
                return
            }
        }
        var newPlayer = Player(id: dbUser.uid!)
        newPlayer.update(dbUser)
        self.players.append(newPlayer)
        ///////////////////  
        //self.playerListChanged = true
        DataHolder.controller.game.playerListChanged = true
        self.p.write("AddPlayer: Player successfully added Id: \(dbUser.uid).")
    }
    
    
    
    func setPlayerImg(pid: String, image: UIImage) {
        
        if me.id == pid {
            me.image = image
            return
        }
        
        for p in players {
            if p.id == pid {
                p.image = image
                return
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


