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

    var hostId = ""
    private let playersLock = NSLock()
    let p = Printer(tag: "Game", displayPrints: true)

    
    init() {
    }
    
    

    
    
    
    func updatePlayerList(lobby: inout Lobby) {
        
        var playesToBeDeleted: [Int] = []
        var idsToBeDeleted: [Int] = []
        var matchFound = false
        
        playersLock.lock()
        for (index, p) in players.enumerated() {
            matchFound = false

            for (idIndex, id) in lobby.playerIds.enumerated() {
                
                if id == p.id {
                    idsToBeDeleted.append(idIndex)
                    matchFound = true
                    break
                }
            }
            
            if !matchFound {
                playesToBeDeleted.append(index)

            }
        }
        
        
        
        players.remove(atOffsets: IndexSet(playesToBeDeleted))
        playersLock.unlock()
        lobby.playerIds.remove(atOffsets: IndexSet(idsToBeDeleted))
        
        self.p.write("Player list has been updated")
    }
    
    
    
    
    
    func addPlayer(player: Player) {
        if player.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.p.write("AddPlayer: playerId is empty. Id: \(player.id)")
            return }

        playersLock.lock()
        players.append(player)
        playersLock.unlock()
    }
    
    
    
//    func addPlayer(dbUser: DbUser) {
//        if dbUser.uid?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == nil {
//            self.p.write("AddPlayer: playerId is empty. Id: \(dbUser.uid ?? "nil ")")
//            return
//        }
//
//
//        for p in self.players {
//            if p.id == dbUser.uid {
//                p.update(dbUser)
//                return
//            }
//        }
//        var newPlayer = Player(id: dbUser.uid!)
//        newPlayer.update(dbUser)
//        self.players.append(newPlayer)
//        self.p.write("AddPlayer: Player successfully added Id: \(dbUser.uid ?? "nil ")")
//    }
    
    
    
    
    
    
//    func setPlayerImg(pid: String, image: UIImage) {
//
//        if me.id == pid {
//            me.image = image
//            return
//        }
//
//        for p in players {
//            if p.id == pid {
//                p.image = image
//                return
//            }
//        }
//
//        self.p.write("PlayerId: \(pid) not found")
//
//    }
    
    
    
    
    
    
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


