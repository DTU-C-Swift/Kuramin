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
    var actualPlayerSize = 0

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
        actualPlayerSize += 1
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
        var temp = head.nextPlayer
    
        p.write("----------------------- Printing player nodes -----------------------")
        self.p.write("player: \(head.id ), randNum: \(head.randomNumber)")
        
                
        while true {
            
            let k2 = temp?.id ?? ""
            
            if k2 == head.id {
                break
            }
            
            self.p.write("player: \(temp?.id ?? "id is nil"), randNum: \(temp?.randomNumber ?? 0)")
            
            temp = temp?.nextPlayer
            
            
        }
        
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


