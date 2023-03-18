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
    //private (set) var tail: Player?
    
    
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
        //        addDummyPlayers()
        //        printPlayerList()
        //        setPlayerPositions2()
    }
    
    
    
    
    
    
    
    func deleteNode(toBeDeleted: inout Player?) {
        
        if toBeDeleted == nil {
            return
        }
        
        if playerSize == 0 {
            assert(false)
            return
        }
        
        
        if playerSize == 1 {
            head = nil
            playerSize = 0
        }
        else if playerSize > 1 {
            
            if toBeDeleted!.id == head!.id {
                
            }
            
            
            //var
            
            
            
        }
        
    }
    
    
    
    // This funciton adds node to its correct position.
    
    func addNode(nodeToAdd: Player) {  // list size is 0
        
        if head == nil {
            head = nodeToAdd
            head?.nextPlayer = head
            head?.prevPlayer = head
            playerSize = 1
        }
        
        else if head?.id == head?.prevPlayer?.id {   // list size is 1
            assert(playerSize == 1)
            // TODO if node already exist
            
            nodeToAdd.nextPlayer = head
            nodeToAdd.prevPlayer = head
            
            head?.nextPlayer = nodeToAdd
            head?.prevPlayer = nodeToAdd
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
                    
                    let crrPrev = crrNode?.prevPlayer
                    
                    nodeToAdd.nextPlayer = crrNode
                    crrNode?.prevPlayer = nodeToAdd
                    
                    crrPrev?.nextPlayer = nodeToAdd
                    nodeToAdd.prevPlayer = crrPrev
                    
                    
                    if crrNode?.id == head?.id { // in front of the head
                        head = head?.prevPlayer
                    }
                    

                    playerSize += 1
                    
                    return
                }
                
    
                crrNode = crrNode?.nextPlayer
                
            } while crrNode?.id != head?.id
            
            // nodeToAdd is the larges
            let headPrev = head?.prevPlayer
            
            nodeToAdd.prevPlayer = headPrev
            headPrev?.nextPlayer = nodeToAdd
            
            
            nodeToAdd.nextPlayer = head
            head?.prevPlayer = nodeToAdd
            
            playerSize += 1
            
            
            return
        }
        
        
        
    }
    
    

    
    func isInList(node: Player) -> Bool {

        var crrNode = head
        
        repeat {
            assert(crrNode != nil)
            
            if crrNode?.id == node.id {
                return true
            }
            
            crrNode = crrNode?.nextPlayer
            
        } while crrNode?.id != head?.id
        
        return false
        
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
        
        printPlayerList()
        setPlayerPositions()
        
        p.write("Player: \(newPlayer.id) added")
        return newPlayer
        
    }
    
    
    
    
    
    
    
    
    
    func setPlayerPositions() {
        
        playersLock.lock()
        
        if players.count < 1 {
            playersLock.unlock()
            return
            
        }
        
        
        players.append(me)
        let sortedPlayers = players.sorted(by: {$0.randomNumber < $1.randomNumber})
        
        let arrSize = sortedPlayers.count
        
        let head = sortedPlayers[0]
        let last = sortedPlayers[arrSize - 1]
        
        head.nextPlayer = sortedPlayers[1]
        head.prevPlayer = last
        
        
        last.nextPlayer = head
        last.prevPlayer = sortedPlayers[arrSize - 2]
        
        
        for i in 1..<sortedPlayers.count - 1 {
            
            sortedPlayers[i].prevPlayer = sortedPlayers[i - 1]
            sortedPlayers[i].nextPlayer = sortedPlayers[i + 1]
            
        }
        
        playersLock.unlock()
        printPlayersNode(head: me)
        playersLock.lock()
        
        
        
        switch sortedPlayers.count {
            
        case 2:
            fiveFromRight = me.nextPlayer
            
        case 3:
            fiveFromRight = me.nextPlayer
            sixFromRight = fiveFromRight?.nextPlayer
            
        case 4:
            twoFromRight = me.nextPlayer
            fiveFromRight = twoFromRight?.nextPlayer
            sixFromRight = fiveFromRight?.nextPlayer
            
        case 5:
            twoFromRight = me.nextPlayer
            fourFromRight = twoFromRight?.nextPlayer
            fiveFromRight = fourFromRight?.nextPlayer
            sixFromRight = fiveFromRight?.nextPlayer
            
        case 6:
            twoFromRight = me.nextPlayer
            threeFromRight = twoFromRight?.nextPlayer
            fourFromRight = threeFromRight?.nextPlayer
            fiveFromRight = fourFromRight?.nextPlayer
            sixFromRight = fiveFromRight?.nextPlayer
            
            
            
        case 7:
            twoFromRight = me.nextPlayer
            threeFromRight = twoFromRight?.nextPlayer
            fourFromRight = threeFromRight?.nextPlayer
            fiveFromRight = fourFromRight?.nextPlayer
            sixFromRight = fiveFromRight?.nextPlayer
            sevenFromRight = sixFromRight?.nextPlayer
            
        default:
            
            oneFromRight = me.nextPlayer
            twoFromRight = oneFromRight?.nextPlayer
            threeFromRight = twoFromRight?.nextPlayer
            fourFromRight = threeFromRight?.nextPlayer
            fiveFromRight = fourFromRight?.nextPlayer
            sixFromRight = fiveFromRight?.nextPlayer
            sevenFromRight = sixFromRight?.nextPlayer
            
        }
        
        playersLock.unlock()
        
    }
    
    
    
    
    func printPlayersNode(head: Player) {
        
        
        playersLock.lock()
        p.write("----------------------- Printing player nodes -----------------------")
        var crrNode = head
        
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
            
        } while crrNode.id != head.id
        
        
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
    
    
    
    
    
    
    
    
    
    func addDummyPlayers() {
        
        for i in 0..<7 {
            let newPlayer = Player(id: "id\(i)")
            newPlayer.setFullName(fullName: "player\(i)")
            var rand = Int(arc4random_uniform(10000))
            newPlayer.setRandomNum(randNum: rand)
            
            players.append(newPlayer)
        }
        
        
    }
    
    
    
    func printPlayerList() {
        
        playersLock.lock()
        self.p.write("/------------------ Printing player list ------------------------/")
        for p in players {
            self.p.write("Id: \(p.id), name: \(p.displayName), randNum: \(p.randomNumber)")
        }
        
        p.write("Id: \(me.id), name: \(me.displayName), randNum: \(me.randomNumber)")
        
        playersLock.unlock()
    }
    
    
    
    
    
    
}


