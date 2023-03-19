//
//  Game.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import Foundation
import SwiftUI

public class Game : ObservableObject {
    private (set) var id: String = ""
    @Published private (set) var me: Player = Player(id: Util().NOT_SET)
    var head: Player?
    private let lockNodeList = NSLock()
    
    private (set) var playerSize = 0
    
    private (set) var hostId = ""
    let p = Printer(tag: "Game", displayPrints: true)
    private (set) var isGameStarted = false
    
    
    @Published var oneFromRight: Player?
    @Published var twoFromRight: Player?
    @Published var threeFromRight: Player?
    @Published var fourFromRight: Player?
    @Published var fiveFromRight: Player?
    @Published var sixFromRight: Player?
    @Published var sevenFromRight: Player?
    
    
    
    
    
    init () {
        //me.setRandomNum(randNum: 530)
        //addNode(nodeToAdd: me)

    }
    
    
//    func dd() {
//        addDummyPlayers(val: 1)
//        printPlayersNode(head: head)
//        setPlayerPositions()
//    }

   

    
    
    
    
    func updatePlayerList(lobby: Lobby) {

        if playerSize <= 0 || lobby.players.isEmpty {return}
 
        if isGameStarted {
            //----TODO---/
            return
        }
        
        var needPlayerPositionUpdate = false

        for crrLobbyP in lobby.players {
            
            if removeNode(pid: crrLobbyP.pid) && !needPlayerPositionUpdate {
                needPlayerPositionUpdate = true
            }
            
        }
        
        
    

        if needPlayerPositionUpdate {
            setPlayerPositions()
            self.p.write("Player list has been updated")
        }
        
        p.write("No players to update the list")

    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /// This funciton adds node to its correspondin position decided by 'randomNum'.
    /// - Note: Updates if there exists a player with the same id
    /// - Note: Unlock "lockNodeList"
    /// - Note: setPlayerPosition method must be called after this method
    /// - Note: returns true if item is added,  else false if it is updated

    func addNode(nodeToAdd: Player) -> Bool {  // list size is 0
        
        if updateIfExist(player:  nodeToAdd) {
            return false
        }
        
        
        
        lockNodeList.lock()
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
                    
                    lockNodeList.unlock()
                    
                    
                    //--------------------------------//
                    //setPlayerPositions()
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
        
        lockNodeList.unlock()
        
        return true
        //setPlayerPositions()
        
    }
    
    

    /// Note: Unlock "lockNodeList"
    func isInList(node: Player) -> Bool {

        lockNodeList.lock()
        var crrNode = head
        
        repeat {
            assert(crrNode != nil)
            
            if crrNode?.id == node.id {
                lockNodeList.unlock()
                return true
            }
            
            crrNode = crrNode?.nextPlayer
            
        } while crrNode?.id != head?.id
        
        lockNodeList.unlock()
        
        return false
        
    }
    
    
    

    /// Note: Unlock "lockNodeList"
    func updateIfExist(player: Player) -> Bool {
        
        
        if let pRef =  getPlayerRef(pid: player.id) {
            
            pRef.updateInfo(player: player)
            return true
        }
        
        return false
    }
    
    
    
    /// Provides reference of the desired player if it exists
    ///
    /// Note: Unlock "lockNodeList"
    
    
    func getPlayerRef(pid: String) -> Player? {

        lockNodeList.lock()
        
        if playerSize <= 0 {
            lockNodeList.unlock()
            return nil
        }
        
        
        
        var crrNode = head
        
        repeat {
            assert(crrNode != nil)
            
            if crrNode?.id == pid {
                lockNodeList.unlock()
                return crrNode
            }
            
            crrNode = crrNode?.nextPlayer
            
        } while crrNode?.id != head?.id
        
        lockNodeList.unlock()
        
        return nil
        
    }

    
    
    
    
    /// setPlayerPosition method must be called after this method
    
    func removeNode(nodeToRemove: Player) -> Bool {
        var isPlayerRemoved = false

        lockNodeList.lock()

        // If the list is empty, there's nothing to remove.
        guard let head = head else {
            lockNodeList.unlock()
            return false
        }
        
        if head === nodeToRemove {
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
            while current !== head && current !== nodeToRemove {
                current = current?.nextPlayer
            }
            
            if current === nodeToRemove {
                // Remove the node by updating the next and previous pointers.
                current!.prevPlayer!.nextPlayer = current?.nextPlayer
                current!.nextPlayer?.prevPlayer = current?.prevPlayer
                
                playerSize -= 1
                isPlayerRemoved = true
            }
        }
        
        lockNodeList.unlock()
        
        
        if isPlayerRemoved {
            p.write("Player id \(nodeToRemove.id) has been removed")
            //setPlayerPositions()
            return true
        }
        
        p.write("Player id \(nodeToRemove.id) not found to remove")

        return false
    }
    
    


    /// setPlayerPosition method must be called after this method
    
    func removeNode(pid: String) -> Bool {
                
        var isPlayerRemoved = false
        lockNodeList.lock()
        
        // If the list is empty, there's nothing to remove.
        guard let head = head else {
            lockNodeList.unlock()
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
        
        
        lockNodeList.unlock()
        
        if isPlayerRemoved {
            p.write("Player id \(pid) has been removed")
            //setPlayerPositions()
            return true
        }
        
        p.write("Player id \(pid) not found to remove")
        return false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func setPlayerPositions() {
        
        lockNodeList.lock()
                
        
        switch playerSize {
            
        case 1:
            p.write("Only me")
            
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
            fourFromRight = twoFromRight?.nextPlayer
            fiveFromRight = fourFromRight?.nextPlayer
            sixFromRight = fiveFromRight?.nextPlayer
            
            oneFromRight = nil
            threeFromRight = nil
            sevenFromRight = nil
            
        case 6:
            twoFromRight = me.nextPlayer
            threeFromRight = twoFromRight?.nextPlayer
            fourFromRight = threeFromRight?.nextPlayer
            fiveFromRight = fourFromRight?.nextPlayer
            sixFromRight = fiveFromRight?.nextPlayer
            
            oneFromRight = nil
            sevenFromRight = nil
            
            
        case 7:
            twoFromRight = me.nextPlayer
            threeFromRight = twoFromRight?.nextPlayer
            fourFromRight = threeFromRight?.nextPlayer
            fiveFromRight = fourFromRight?.nextPlayer
            sixFromRight = fiveFromRight?.nextPlayer
            sevenFromRight = sixFromRight?.nextPlayer
            
            oneFromRight = nil
            
        case 8:
            
            oneFromRight = me.nextPlayer
            twoFromRight = oneFromRight?.nextPlayer
            threeFromRight = twoFromRight?.nextPlayer
            fourFromRight = threeFromRight?.nextPlayer
            fiveFromRight = fourFromRight?.nextPlayer
            sixFromRight = fiveFromRight?.nextPlayer
            sevenFromRight = sixFromRight?.nextPlayer
            
        default:
            p.write("Player list not set")
            
        }
        
        lockNodeList.unlock()
        printPlayersNode(head: head)

    }
    
    
    
    
    func printPlayersNode(head: Player?) {
        p.write("----------------------- Printing player nodes -----------------------")

        lockNodeList.lock()
        
        if playerSize <= 0 {
            lockNodeList.unlock()
            return
        }
         var crrNode = head!

        for  _ in 0..<playerSize  {
            
            self.p.write("player: \(crrNode.id ), randNum: \(crrNode.randomNumber )")
            
            crrNode = crrNode.nextPlayer!
        }
        
        lockNodeList.unlock()

        
    }
    
    
    
    
    
    

    
    func addDummyPlayers(val: Int) {
        
        for i in 0..<val {
            let newPlayer = Player(id: "id\(i)")
            newPlayer.setFullName(fullName: "player\(i)")
            var rand = Int(arc4random_uniform(10000))
            newPlayer.setRandomNum(randNum: rand)
            
            //players.append(newPlayer)
            
            addNode(nodeToAdd: newPlayer)
        }
        
        
    }
    
    
    func setGameId(gid: String) {
        if id != gid && gid != Util().NOT_SET {
            self.id = gid
        }
    }

    
    
    
}


