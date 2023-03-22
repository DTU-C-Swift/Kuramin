//
//  GameTest.swift
//  Kuramin
//
//  Created by MD. Zahed on 15/03/2023.
//

import Foundation
import FirebaseAuth
import SwiftUI


class SubGameTest : ObservableObject{
    let p = Printer(tag: "SubGameTest", displayPrints: true)
    @Published var testPassed: Bool = false


    

    func main() {
        updateMethodTest()
        goToLobby_usecase_test(onSuccess: goToLobby_usecase_test_onSuccess)
        
        
    }
    
    
    
    
    func goToLobby_usecase_test(onSuccess: @escaping (Controller) -> Void) {
        
        
        let controller = Controller()
        controller.service.MATCHES = "test"

        let game = controller.game
        game.setGameId(gid: "goToLobby_usecase_test")

        controller.observeMeInDB()
        
        controller.service.deleteLobby()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            assert(game.me.cardsInHand == -1)
            assert(game.playerSize == 0)

            controller.goToLobby(addDummyPlayer: false)
            
            // lets player to be fected from db
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                assert(game.me.cardsInHand != -1)
                assert(game.playerSize == 1)
                assert(game.head === game.me)
                assert(game.head!.id == game.me.id)
                
                
                
                
                // head: me
                // Adds some dummy players in db
                controller.goToLobby(addDummyPlayer: true)
                controller.goToLobby(addDummyPlayer: true)
                controller.goToLobby(addDummyPlayer: true)

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    // Assuming: playerSize 4
                    assert(game.playerSize == 4)
                    
                    onSuccess(controller)
                    



                }
            }
        
        }

    }
    
    
    func goToLobby_usecase_test_onSuccess(controller: Controller) {

        //controller.service.deleteLobby()

        
        
        
        self.testPassed = true

        //service.goToLobby(me: player, controller:  self, shouldCall_lobbyObserver: false)

        
    }
    
    
    
  
    
    
    
    func updateMethodTest() {
        var controller = Controller()
        let game = controller.game
        var dbPlayers: [DbPlayer] = []
        
        

        
        for i in 1...7 {
            
            let newPlayer = DbPlayer(pName: "Player\(i) lastname", pid: "playerId\(i)",
                                     randomNum: i, cardsInHand: Int(arc4random_uniform(10)))
            
            dbPlayers.append(newPlayer)
        }
        
        let dbMe = DbPlayer(pName: game.me.fullName, pid: game.me.id, randomNum: 8, cardsInHand: 10)
        dbPlayers.append(dbMe)
        
        // dbPlayers: p1, p2, p3, p4, p5, p6, p7, me
        
        
        
        let p1 = dbPlayers[0].createPlayer()
        let p2 = dbPlayers[1].createPlayer()
        
        
        // head     =>:
        // Expectation: p1, p2
        assert(game.addNode(nodeToAdd: p2))
        assert(game.addNode(nodeToAdd: p1))
        
        
        assert(game.playerSize == 2)
        assert(game.head!.id == p1.id)
        assert(game.head!.nextPlayer!.id == p2.id)


        
    
        
        
        // head: p1, p2
        // Expectation: p1, p2, p3, p4
        
        game.addNode(nodeToAdd: dbPlayers[3].createPlayer())
        game.addNode(nodeToAdd: dbPlayers[2].createPlayer())
        
        assert(game.playerSize == 4)
        
        var temp = game.head
        for _ in 0..<game.playerSize-1 {
            
            if temp == nil {assert(false)} // temp should not be nil
            
            if temp!.randomNumber < temp!.nextPlayer!.randomNumber {
                
            }
            else {assert(false)}
            
            
            temp = temp?.nextPlayer
            
        }
        
        
        
        
        
        
        // head:p1, p2, p3, p4
        // Expectation: p1, p2
        
        dbPlayers.remove(at: 0)
        dbPlayers.remove(at: 0)
        // dbPlayers: p3, p4, p5, p6, p7, me
        var lobby = Lobby(gameId: "12345", host: dbPlayers[1].pid, whosTurn: Util.NOT_SET, players: dbPlayers)

        game.updatePlayerList(lobby: lobby)
        assert(game.playerSize == 2)
        assert(game.head !== game.head!.nextPlayer)
        
    
        
    }
    
    
    

    
    
    
}
