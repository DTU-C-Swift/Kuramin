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
    @Published private (set) var me: Player = Player(id: Util().MY_DUMMY_ID)
    var actualPlayerSize = 0

    var hostId = ""
    private let playersLock = NSLock()
    let p = Printer(tag: "Game", displayPrints: true)
    var isGameStarted = false

    
    init () {
        addDummyPlayers()
    }


    
    
    func updatePlayerList(lobby: Lobby) {
        
        if isGameStarted {
            //----TODO---/
            //self.updatePlayerList2(lobby: &lobby)
            return
        }
        
        
        var playesToBeDeleted_FromGame: [Int] = []
        
        playersLock.lock()
        
        for (index, crrGP) in players.enumerated() {

            if !lobby.players.contains(where: {$0.pid == crrGP.id}){
                playesToBeDeleted_FromGame.append(index)
                actualPlayerSize -= 1
                
            }

        }
        
        
        players.remove(atOffsets: IndexSet(playesToBeDeleted_FromGame))
        playersLock.unlock()

        
        self.p.write("Player list has been updated")
    }

    
    
    
    func getPlayerRef(pid: String) -> Player? {
        if pid.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.p.write("PlayerId is empty. Id: \(pid). (getPlayerRef)")
            return nil
            
            //assert(false)
        }
        
        playersLock.lock()
        
        for crrP in players {
            
            if crrP.id == pid {
                
                playersLock.unlock()
                return crrP
            }
        }
        
        
        
        
        let newPlayer = Player(id: pid)
        players.append(newPlayer)
        actualPlayerSize += 1
        playersLock.unlock()
        
        p.write("Player: \(newPlayer.id) added")
        return newPlayer
        
    }
    
    
    
    
    func setPlayerPosition() {
        
        
        var sortedPlayers = players.sorted(by: {$0.randomNumber < $1.randomNumber})
        
        var newPlayers: [Player] = []
        
        var startedIndex: Int?
        
        for (index, crrP) in sortedPlayers.enumerated() {
            
            if me.randomNumber <= crrP.randomNumber {
                newPlayers.append(crrP)
                startedIndex = index
                
            } else {
                
                
            }
        }
        
        
        if let startedIndex = startedIndex {
            
            for i in 0...startedIndex-1 {
                
                newPlayers.append(players[i])
            }
            
        }
        
        players = newPlayers
        
        printPlayerList()
        
    }
    
    
    
    
    
    
//    func addPlayer2(player: Player) {
//
//
//        if isGameStarted {
//            self.p.write("Player can't be added, since game has already started")
//            return
//        }
//
//        if player.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            self.p.write("AddPlayer: playerId is empty. Id: \(player.id)")
//            return
//
//        }
//
//        if players.count > 6 {
//            self.p.write("Player list size is \(players.count). So, no more player is allowed")
//            return
//        }
//
//
//        for (index, crrP) in players.enumerated() {
//
//            if crrP.id == player.id {
//
//                if crrP.isItSame(player: player) {
//                    return
//
//                } else {break}
//
//
//            }
//
//        }
//
//
//
//        playersLock.lock()
//        players.append(player)
//        actualPlayerSize += 1
//        printPlayerList()
//        playersLock.unlock()
//    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //----------------------------------------------------------------------------------//
    
    
    
    // TODO if the playe that is leaving is the host?
    
    
//    func updatePlayerList(lobby: inout FirstLobby) {
//
//        if isGameStarted {
//            self.updatePlayerList2(lobby: &lobby)
//            return
//        }
//
//
//        var playesToBeDeleted: [Int] = []
//        var idsToBeDeleted: [Int] = []
//        var matchFound = false
//
//        playersLock.lock()
//        for (index, p) in players.enumerated() {
//            matchFound = false
//
//            for (idIndex, id) in lobby.playerIds.enumerated() {
//
//                if id == p.id {
//                    idsToBeDeleted.append(idIndex)
//                    matchFound = true
//                    break
//                }
//            }
//
//            if !matchFound {
//                playesToBeDeleted.append(index)
//                actualPlayerSize += -1
//            }
//        }
//
//
//
//        players.remove(atOffsets: IndexSet(playesToBeDeleted))
//        lobby.playerIds.remove(atOffsets: IndexSet(idsToBeDeleted))
//        playersLock.unlock()
//
//
//        self.p.write("Player list has been updated")
//    }
    
    
    
    
    // This update method should be called if the game has startet
    private func updatePlayerList2(lobby: inout FirstLobby) {
        
        
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
                
                p.setIsLeft(isLeft: true)
                
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
                    
                    player.setIsLeft(isLeft: false)
                    
                    players[index] = player
                    actualPlayerSize += 1
                }
                

                playersLock.unlock()
                return
            }
        }
        
        

        player.setIsLeft(isLeft: false)
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
        

        player.setIsLeft(isLeft: false)
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
                                
                player.setIsLeft(isLeft: false)
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
    
    
    
    
    
    
    func addDummyPlayers() {

        for i in 0..<2 {
            let newPlayer = Player(id: "id\(i)")
            newPlayer.setFullName(fullName: "player\(i)")
            players.append(newPlayer)
        }


    }
    
    
    
    func printPlayerList() {
        self.p.write("Printing player list")
        for p in players {
            self.p.write("Id: \(p.id), name: \(p.displayName)")
        }
        
    }

    
    
    
    
    
    
    
    
    
    
    

}


