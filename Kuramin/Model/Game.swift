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
    var isGameStarted = false

    
    init() {
    }
    
    

    
    
    
    func updatePlayerList(lobby: inout Lobby) {
        
        if isGameStarted {
            self.updatePlayerList2(lobby: &lobby)
            return
        }
        
        
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
        lobby.playerIds.remove(atOffsets: IndexSet(idsToBeDeleted))
        playersLock.unlock()

        
        self.p.write("Player list has been updated")
    }
    
    
    
    
    // This update method should be called if the game has startet
    func updatePlayerList2(lobby: inout Lobby) {
        
        
        var idsToBeDeleted: [Int] = []
        var matchFound = false
        
        playersLock.lock()
        for p in players {
            matchFound = false

            for (idIndex, id) in lobby.playerIds.enumerated() {
                
                if id == p.id {
                    idsToBeDeleted.append(idIndex)
                    matchFound = true
                    break
                }
            }
            
            if !matchFound {
                p.isLeft = true

            }
        }
        
        
        
        lobby.playerIds.remove(atOffsets: IndexSet(idsToBeDeleted))
        playersLock.unlock()

        
        self.p.write("Player list has been updated")
        
        
    }
    
    
    
    
    func addPlayer(player: Player) {
        
        if players.count >= 7 {
            self.p.write("Player can't be added (player size already 8)")
            return
        }
        
        if player.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.p.write("AddPlayer: playerId is empty. Id: \(player.id)")
            return }

        playersLock.lock()
        
        if players.contains(where: {$0.id == player.id}) {
            playersLock.unlock()
            return
        }
        
        
        players.append(player)
        printPlayerList()
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
    
    
    
    
    
    
//    func addDummyPlayers() {
//
//        for i in 1...8 {
//            let newPlayer = Player(id: "id\(i)")
//            newPlayer.id = UUID().uuidString
//            newPlayer.displayName = "player" + String(i)
//            if i <= 7 {
//                newPlayer.isNotDummy = true
//            }
//            players.append(newPlayer)
//        }
//
//
//    }
    
    
    
    func printPlayerList() {
        self.p.write("Printing player list")
        for p in players {
            self.p.write("Id: \(p.id), name: \(p.displayName)")
        }
        
    }

}


