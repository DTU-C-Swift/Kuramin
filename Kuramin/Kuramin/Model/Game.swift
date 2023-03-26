//
//  Game.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import Foundation
import SwiftUI

public class Game : ObservableObject {
    private (set) var id: String = Util.NOT_SET
    var head: Player?
    private let semephore = DispatchSemaphore(value: 1)
    private (set) var playerSize = 0
    
    private (set) var hostId = Util.NOT_SET
    let p = Printer(tag: "Game", displayPrints: true)
    private var lockCount = 0
    let deck = Deck()
    
    private (set) var isGameStarted = false
    
    @Published private (set) var me: Player = Player(id: Util.NOT_SET)
    @Published private (set) var oneFromRight: Player?
    @Published private (set) var twoFromRight: Player?
    @Published private (set) var threeFromRight: Player?
    @Published private (set) var fourFromRight: Player?
    @Published private (set) var fiveFromRight: Player?
    @Published private (set) var sixFromRight: Player?
    @Published private (set) var sevenFromRight: Player?
    @Published private (set) var isLandingInLobbySucceded = false
    @Published var isWaitingToLandInLobby = false
    @Published var cardOnBoard: Card?
    
    
    private (set) var playerTurnId = Util.NOT_SET
    
    @Published private (set) var isMyTurn = false
    
    var subGame = SubGame()
    
    
    
    init () {
        //me.setRandomNum(randNum: 530)
        //addNode(nodeToAdd: me)
        
        
    }
    
    
//    func dd() {
//        addDummyPlayers(val: 1)
//        printPlayersNode(head: head)
//        setPlayerPositions()
//    }

   

    private func lock(_ str: String) {
        lockCount += 1
        p.write("locked: \(str) \(lockCount)")
        semephore.wait()
    }
    
    private func unlock(_ str: String) {
        semephore.signal()
        lockCount += -1
        p.write("Unlocked: \(str) \(lockCount)")

    }
    
    
    
    
    func updatePlayerList(lobby: Lobby) {
        lock("updatePlayerList")
        
        if playerSize <= 0 || lobby.players.isEmpty {
            unlock("updatePlayerList")
            return
        }
 
        if isGameStarted {
            //----TODO---/
            unlock("updatePlayerList")
            return
        }
        
        var needPlayerPositionUpdate = false

        
        
        if playerSize == 1 {
            
            if !lobby.players.contains(where: {$0.pid == head!.id}) {
                if removeNode(pid: head!.id, shouldLock: false) {}
                needPlayerPositionUpdate = true

            }

            
        } else {
            
    
            var crrP = head
            
            for _ in 0..<playerSize {
                
                assert(crrP!.nextPlayer != nil)
                
                if !lobby.players.contains(where: {$0.pid == crrP!.nextPlayer!.id}) {
                    if removeNode(pid: crrP!.nextPlayer!.id, shouldLock: false) {}
                    needPlayerPositionUpdate = true
                    
                }
                
                crrP = crrP?.nextPlayer
            }
            
            
            
        }
        
        
        unlock("updatePlayerList")
        

        if needPlayerPositionUpdate {
            setPlayerPositions(shouldLock: true)
            self.p.write("Player list has been updated")
        }
        
        p.write("No players to update the list")

    }

    
    
    
    
    
    /// This funciton adds node to its correspondin position decided by 'randomNum'.
    /// - Note: Updates if there exists a player with the same id
    /// - Note: Unlock "lockNodeList"
    /// - NOT FOR NOW setPlayerPosition method must be called after this method
    /// - Note: returns true if item is added,  else false if it is updated

    func addNode(nodeToAdd: Player) -> Bool {  // list size is 0
        
        if playerSize >= 8 {
            p.write("Not allow to add more player to game. Already 8 players.")
            return false
        }
        
        if updateIfExist(player:  nodeToAdd) {
            return false
        }
        
        lock("addNode")
        if head == nil {
            head = nodeToAdd
            head!.nextPlayer = head
            head!.prevPlayer = head
            playerSize = 1
        }
        
        else if head!.id == head!.prevPlayer!.id {   // list size is 1
            assert(playerSize == 1)
            
            
            nodeToAdd.nextPlayer = head
            nodeToAdd.prevPlayer = head
            
            head!.nextPlayer = nodeToAdd
            head!.prevPlayer = nodeToAdd
            playerSize += 1
            
                        
            
            if head!.randomNumber > nodeToAdd.randomNumber {
                
                head = nodeToAdd
            }
            
        }
        

        else {
            
            assert(playerSize >= 2)
            
            var crrNode = head
            
            repeat {
                assert(crrNode != nil)
                
                
                if nodeToAdd.randomNumber < crrNode!.randomNumber {  // "nodeToAdd" is smaller then current node.
                    
                    let crrPrev = crrNode!.prevPlayer
                    
                    nodeToAdd.nextPlayer = crrNode
                    crrNode!.prevPlayer = nodeToAdd
                    
                    crrPrev!.nextPlayer = nodeToAdd
                    nodeToAdd.prevPlayer = crrPrev
                    
                    
                    if crrNode!.id == head!.id { // in front of the head
                        head = head!.prevPlayer
                    }
                    

                    playerSize += 1
                    
                    unlock("addNode")
                    
                    //--------------------------------//
                    setPlayerPositions(shouldLock: true)
                    return true
                }
                
    
                crrNode = crrNode!.nextPlayer
                
            } while crrNode!.id != head!.id
            
            // nodeToAdd is the larges
            let headPrev = head!.prevPlayer
            
            nodeToAdd.prevPlayer = headPrev
            headPrev?.nextPlayer = nodeToAdd
            
            
            nodeToAdd.nextPlayer = head
            head?.prevPlayer = nodeToAdd
            
            playerSize += 1
            
            

        }
        
        unlock("addNode")
        setPlayerPositions(shouldLock: true)
        return true
        
    }
    
    

    /// Note: Unlock "lockNodeList"
    func isInList(node: Player) -> Bool {

        lock("isInList")
        var crrNode = head
        
        repeat {
            assert(crrNode != nil)
            
            if crrNode?.id == node.id {
                unlock("isInList")
                return true
            }
            
            crrNode = crrNode?.nextPlayer
            
        } while crrNode?.id != head?.id
        
       unlock("isInList")

        return false
        
    }
    
    
    

    /// Note: Unlock "lockNodeList"
    func updateIfExist(player: Player) -> Bool {
        
        
        if let pRef =  getPlayerRef(pid: player.id, shouldLock: true) {
            
            pRef.updateInfo(player: player)
            return true
        }
        
        return false
    }
    
    
    
    /// Provides reference of the desired player if it exists
    ///
    /// Note: Unlock "lockNodeList"
    
    
    func getPlayerRef(pid: String, shouldLock: Bool) -> Player? {

        if shouldLock {
            lock("getPlayerRef")
        }
        
        if playerSize <= 0 {
            
            if shouldLock {
                unlock("getPlayerRef")
            }
            return nil
        }
        
        
        
        var crrNode = head
        
        
        for _ in 0..<playerSize {
            assert(crrNode != nil)

            if crrNode?.id == pid {
                
                if shouldLock {
                    unlock("getPlayerRef")
                }
                return crrNode
            }
            
            crrNode = crrNode?.nextPlayer
        }
        
        
        if shouldLock {
            unlock("getPlayerRef")
        }
        
        return nil
        
    }

    
    
    



    /// NOT FOR NOW setPlayerPosition method must be called after this method
    
    func removeNode(pid: String, shouldLock: Bool) -> Bool {
                
        var isPlayerRemoved = false
        if shouldLock {
            lock("removeNode")
        }
        
        
        // If the list is empty, there's nothing to remove.
        guard let head = head else {
            
            if shouldLock {
                unlock("removeNode")
            }
            return false
        }
        
        if head.id == pid {
            // Removing the head node.
            if head.nextPlayer === head {
                // Removing the only node in the list.
                self.head = nil
                playerSize = 0
                isPlayerRemoved = true
            } else {
                // Removing the head node of a list with more than one node.
                self.head = head.nextPlayer
                self.head!.prevPlayer = head.prevPlayer
                head.prevPlayer!.nextPlayer = self.head
                playerSize -= 1
                isPlayerRemoved = true
            }
        } else {
            // Search for the node to remove.
            var current = head.nextPlayer
            while current !== head && current?.id != pid {
                current = current?.nextPlayer
            }
            
            if current?.id == pid {
                // Remove the node by updating the next and previous pointers.
                current!.prevPlayer!.nextPlayer = current?.nextPlayer
                current!.nextPlayer?.prevPlayer = current?.prevPlayer
                
                playerSize -= 1
                isPlayerRemoved = true
            }
        }
        
        if shouldLock {
            unlock("removeNode")
        }
        
        
        if isPlayerRemoved {
            p.write("Player id \(pid) has been removed")
            setPlayerPositions(shouldLock: shouldLock)
            return true
        }
        
        p.write("Player id \(pid) not found to remove")
        return false
    }
    
    
    
    
    /// Removes all element from 'head' and set 'me.next' and 'me.prev' to itself. PlayerSize will 0
    func remove_all_players() {
        
        lock("remove_all_players")
        
        me.nextPlayer = me
        me.prevPlayer = me
        playerSize = 0
        
        head = nil
        setPlayerPositions(shouldLock: false)
        unlock("remove_all_players")
    }
    
    
    
    
    
    
    ///- Note: If 'me' or me.next is nil, then this function will have effects.
    
    func setPlayerPositions(shouldLock: Bool) {
        
        if shouldLock {
            lock("setPlayerPositions")
        }
         
        
        if playerSize > 1 {
            if me.nextPlayer == nil || me.nextPlayer === me {
                unlock("setPlayerPositions")
                p.write("'me' is nil, so setting player position is not possible.")
                return

            }
            
        }
        

        
        switch playerSize {

        case 2:
            fiveFromRight = me.nextPlayer
            
            oneFromRight = nil
            twoFromRight = nil
            threeFromRight = nil
            fourFromRight = nil
            sixFromRight = nil
            sevenFromRight = nil
            
        case 3:
            fiveFromRight = me.nextPlayer
            sixFromRight = fiveFromRight?.nextPlayer
            
            oneFromRight = nil
            twoFromRight = nil
            threeFromRight = nil
            fourFromRight = nil
            sevenFromRight = nil
            
        case 4:
            twoFromRight = me.nextPlayer
            fiveFromRight = twoFromRight?.nextPlayer
            sixFromRight = fiveFromRight?.nextPlayer
            
            oneFromRight = nil
            threeFromRight = nil
            fourFromRight = nil
            sevenFromRight = nil
            
        case 5:
            twoFromRight = me.nextPlayer
            fourFromRight = twoFromRight!.nextPlayer
            fiveFromRight = fourFromRight!.nextPlayer
            sixFromRight = fiveFromRight!.nextPlayer
            
            oneFromRight = nil
            threeFromRight = nil
            sevenFromRight = nil
            
        case 6:
            twoFromRight = me.nextPlayer
            threeFromRight = twoFromRight!.nextPlayer
            fourFromRight = threeFromRight!.nextPlayer
            fiveFromRight = fourFromRight!.nextPlayer
            sixFromRight = fiveFromRight!.nextPlayer
            
            oneFromRight = nil
            sevenFromRight = nil
            
            
        case 7:
            twoFromRight = me.nextPlayer
            threeFromRight = twoFromRight!.nextPlayer
            fourFromRight = threeFromRight!.nextPlayer
            fiveFromRight = fourFromRight!.nextPlayer
            sixFromRight = fiveFromRight!.nextPlayer
            sevenFromRight = sixFromRight!.nextPlayer
            
            oneFromRight = nil
            
        case 8:
            
            oneFromRight = me.nextPlayer
            twoFromRight = oneFromRight!.nextPlayer
            threeFromRight = twoFromRight!.nextPlayer
            fourFromRight = threeFromRight!.nextPlayer
            fiveFromRight = fourFromRight!.nextPlayer
            sixFromRight = fiveFromRight!.nextPlayer
            sevenFromRight = sixFromRight!.nextPlayer
            
        default:
            oneFromRight = nil
            twoFromRight = nil
            threeFromRight = nil
            fourFromRight = nil
            fiveFromRight = nil
            sixFromRight = nil
            sevenFromRight = nil
            
        }
        
        if shouldLock {
            unlock("setPlayerPositions")
        }
        printPlayersNode(head: head, shouldLock: shouldLock)

    }
    
    
    
    
    func printPlayersNode(head: Player?, shouldLock: Bool) {
        p.write("----------------------- Printing player nodes -----------------------")

        if shouldLock {
            lock("printPlayersNode")
        }

        if playerSize <= 0 {
            if shouldLock {
                unlock("printPlayersNode")
            }
            return
        }
         var crrNode = head!

        for  _ in 0..<playerSize  {

            self.p.write("player: \(crrNode.id ), randNum: \(crrNode.randomNumber )")

            crrNode = crrNode.nextPlayer!
        }

        if shouldLock {
            unlock("printPlayersNode")
        }

    }
    
    
    
    
    
    

    
    func addDummyPlayers(val: Int) {
        if addNode(nodeToAdd: me) {}
        
        for i in 0..<val {
            let newPlayer = Player(id: "id\(i)")
            newPlayer.setFullName(fullName: "player\(i)")
            let rand = Int(arc4random_uniform(10000))
            newPlayer.setRandomNum(randNum: rand)
            
            //players.append(newPlayer)
            
            if addNode(nodeToAdd: newPlayer) {}
        }
        setPlayerPositions(shouldLock: true)
    }
    
    
    func setGameId(gid: String) {
        lock("setGameId")
        if id != gid && gid != Util.NOT_SET {
            self.id = gid
        }
        unlock("setGameId")
    }

    
    func setHostId(hostId: String) {
        
        lock("setHostId")
        
        if self.hostId != hostId {
            self.hostId = hostId
        }
        
        unlock("setHostId")

    }
    
    
    func setIsWaitingToLandInLobby(val: Bool) {
        if isWaitingToLandInLobby == val {return}
        
        Task {
            await MainActor.run(body: {
                p.write("setIsWaitingToLandInLobby")
                isWaitingToLandInLobby = val
            })
        }
    }
    
    
    func setIsLandingInLobbySucceded(val: Bool) {
        if isLandingInLobbySucceded == val {return}
        
        Task {
            await MainActor.run(body: {
                isLandingInLobbySucceded = val
                p.write("setIsLandingInLobbySucceded")
            })
        }
    }
    
    
//    func setIsMyturn(_ val: Bool) {
//        if isMyTurn == val {return}
//        
//        Task {
//            
//            await MainActor.run(body: {
//                isMyTurn = val
//            })
//        }
//    }
    
    
    
    
    func setPlayerTurnId(pid: String) {
        if pid.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true || pid == Util.NOT_SET {
            return
        }
        
        if playerTurnId != pid {
            self.playerTurnId = pid
            
            if pid == me.id {
                self.isMyTurn = true
            }
            
            
        }
        
    }
    
    
    
    
    func setCardOnBoard(card: Card) {
        cardOnBoard = card
    }
}


