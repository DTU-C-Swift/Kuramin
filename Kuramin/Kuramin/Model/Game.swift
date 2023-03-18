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
    @Published private (set) var me: Player = Player(id: Util().MY_DUMMY_ID)
    var head: Player?
    private let lockNodeList = NSLock()
    
    var playerSize = 0
    
    var hostId = ""
    private let playersLock = NSLock()
    let p = Printer(tag: "Game", displayPrints: true)
    var isGameStarted = false
    
    
    @Published var oneFromRight: Player?
    @Published var twoFromRight: Player?
    @Published var threeFromRight: Player?
    @Published var fourFromRight: Player?
    @Published var fiveFromRight: Player?
    @Published var sixFromRight: Player?
    @Published var sevenFromRight: Player?
    
    var players: [Player] = []
    
    
    
    
    init () {
        me.setRandomNum(randNum: 530)
        addNode(nodeToAdd: me)

        //        setPlayerPositions2()
    }
    
    
    func dd() {
        addDummyPlayers(val: 1)
        printPlayersNode(head: head)
        setPlayerPositions()
    }

   
    
    
    
    // This funciton adds node to its correct position.
    
    func addNode(nodeToAdd: Player) {  // list size is 0
        
        lockNodeList.lock()
        if head == nil {
            head = nodeToAdd
            head!.nextPlayer = head
            head!.prevPlayer = head
            playerSize = 1
        }
        
        else if head!.id == head!.prevPlayer!.id {   // list size is 1
            assert(playerSize == 1)
            // TODO if node already exist
            
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
                    return
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

        
    }
    
    

    
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
    
    
    
    
    
    
    func removeNode(nodeToRemove: Player) {
        lockNodeList.lock()
        
        // If the list is empty, there's nothing to remove.
        guard let head = head else {
            lockNodeList.unlock()
            return
        }
        
        if head === nodeToRemove {
            // Removing the head node.
            if head.nextPlayer === head {
                // Removing the only node in the list.
                self.head = nil
                playerSize = 0
            } else {
                // Removing the head node of a list with more than one node.
                self.head = head.nextPlayer
                self.head!.prevPlayer = head.prevPlayer
                head.prevPlayer!.nextPlayer = self.head
                playerSize -= 1
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
            }
        }
        
        lockNodeList.unlock()
        
        printPlayersNode(head: head)
        setPlayerPositions()
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
                playerSize -= 1
                
            }
            
        }
        
        
        players.remove(atOffsets: IndexSet(playesToBeDeleted_FromGame))
        playersLock.unlock()
        
        setPlayerPositions()
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
        playerSize += 1
        playersLock.unlock()
        
        //printPlayerList()
        setPlayerPositions()
        
        p.write("Player: \(newPlayer.id) added")
        return newPlayer
        
    }
    
    
    
    
    
    
    
    
    
    func setPlayerPositions() {
        
        playersLock.lock()
                
        
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
        
        playersLock.unlock()
        
    }
    
    
    
    
    func printPlayersNode(head: Player?) {
        
        p.write("----------------------- Printing player nodes -----------------------")

        
        if head == nil {
            p.write("head is nil")
            return
        }
        
        
        playersLock.lock()
        var crrNode = head!
        
        repeat {
            self.p.write("player: \(crrNode.id ), randNum: \(crrNode.randomNumber )")

        
            if crrNode.nextPlayer != nil {
                crrNode = crrNode.nextPlayer!
            }
            else {
                // only one player in the list
                assert(playerSize == 1)
                break
            }
            
        } while crrNode.id != head!.id
        
        
        playersLock.unlock()
        
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
    
    
    
//    func printPlayerList() {
//
//        playersLock.lock()
//        self.p.write("/------------------ Printing player list ------------------------/")
//        for p in players {
//            self.p.write("Id: \(p.id), name: \(p.displayName), randNum: \(p.randomNumber)")
//        }
//
//        p.write("Id: \(me.id), name: \(me.displayName), randNum: \(me.randomNumber)")
//
//        playersLock.unlock()
//    }
//
    
    
    
    
    
}


