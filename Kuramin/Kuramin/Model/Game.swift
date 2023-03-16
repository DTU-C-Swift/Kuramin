//
//  Game.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import Foundation
import SwiftUI

public class Game : ObservableObject {
    var id: String = ""
    @Published var players: [Player] = []
    @Published var me: Player = Player(id: Util().MY_DUMMY_ID)
    var actualPlayerSize = 0

    var hostId = ""
    private let playersLock = NSLock()
    let p = Printer(tag: "Game", displayPrints: true)
    var isGameStarted = false



    // TODO if the playe that is leaving is the host?
    
    
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
                actualPlayerSize += -1
            }
        }
        
        
        
        players.remove(atOffsets: IndexSet(playesToBeDeleted))
        lobby.playerIds.remove(atOffsets: IndexSet(idsToBeDeleted))
        playersLock.unlock()

        
        self.p.write("Player list has been updated")
    }
    
    
    
    
    // This update method should be called if the game has startet
    private func updatePlayerList2(lobby: inout Lobby) {
        
        
        var idsToBeDeleted: [Int] = []
        var matchFound = false
        
        playersLock.lock()
        
        for p in players {
            
            if p.isLeft {continue}
            
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
                p.leftAt = MyDate().getTime()
                actualPlayerSize += -1
                self.p.write("Player: \(p.id), leftAt \(p.leftAt)")
            }
        }
        
        
        lobby.playerIds.remove(atOffsets: IndexSet(idsToBeDeleted))
        playersLock.unlock()

        
        self.p.write("Player list has been updated")
        
        
    }
    
    
    
    
    func addPlayer(player: Player) {
        
        
        if player.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.p.write("AddPlayer: playerId is empty. Id: \(player.id)")
            return }
        
        
        
        if players.count >= 7 {
            
            if actualPlayerSize < 7 {
                replace_with_quitPlayer(player: player)
                return
            }
            
            self.p.write("Player can't be added (player size already \(actualPlayerSize)")
            return
        }
        
        
        

        playersLock.lock()
        
        for (index, curr) in players.enumerated() {
            
            if curr.id == player.id {
                
                if curr.isLeft {
                    
                    player.isLeft = false
                    player.leftAt = ""
                    players[index] = player
                    actualPlayerSize += 1
                    
                }
                

                playersLock.unlock()
                return
            }
        }
        
        
        player.isLeft = false
        player.leftAt = ""
        players.append(player)
        actualPlayerSize += 1
        printPlayerList()
        playersLock.unlock()
    }
    
    
    
    
    
    private func replace_with_quitPlayer(player: Player) {
        
        if replaceIfPlayerExist(player: player) {
            return
        }
        
        
        var earliestPlayerIndex = -1
        var earliestTime = ""
        
        
        playersLock.lock()
        for (index, currP) in players.enumerated() {
            
            
            
            
            
            if !currP.isLeft {continue}
            
            if earliestPlayerIndex == -1 {
                earliestPlayerIndex = index
                earliestTime = currP.leftAt
                continue
            }
            
            
            if MyDate().isEarlier(earlierTime: currP.leftAt, laterTime: earliestTime) {
                earliestPlayerIndex = index
                earliestTime = currP.leftAt
            }
            
        }
        
        
        self.p.write("Replacing \(players[earliestPlayerIndex].displayName) by \(player.displayName)")
        
        player.isLeft = false
        player.leftAt = ""
        players[earliestPlayerIndex] = player
        actualPlayerSize += 1
        playersLock.unlock()
    }
    
    
    func replaceIfPlayerExist(player: Player) -> Bool {
        
        playersLock.lock()
        
        for (index, currP) in players.enumerated() {
            if !currP.isLeft {continue}
            
            if currP.id == player.id {
                actualPlayerSize += 1
                
                player.isLeft = false
                player.leftAt = ""
                players[index] = player
                playersLock.unlock()
                return true
            }
        }
        
        playersLock.unlock()
        return false
    }
    
    
    
    func getActualPlayerIds() -> [String] {
        
        var playerIds: [String] = []
        
        for currP in players {
            if !currP.isLeft {
                playerIds.append(currP.id)
            }
            
            
        }
        
        return playerIds
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


