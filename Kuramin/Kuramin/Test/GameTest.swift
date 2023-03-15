//
//  GameTest.swift
//  Kuramin
//
//  Created by MD. Zahed on 15/03/2023.
//

import Foundation

class GameTest : ObservableObject{
    var controller = Controller()
    let LOBBY = "lobby"
    let pr = Printer(tag: "GameTest", displayPrints: true)
    @Published var testPassed = false
    
    
    
    func testAddPlayer() {
        var game = controller.game
        
        var p1 = Player(id: UUID().uuidString)
        var p2 = Player(id: UUID().uuidString)
        var p3 = Player(id: UUID().uuidString)
        var p4 = Player(id: UUID().uuidString)
        var p5 = Player(id: UUID().uuidString)
        var p6 = Player(id: UUID().uuidString)
        var p7 = Player(id: UUID().uuidString)
        
        
        game.addPlayer(player: p1)
        game.addPlayer(player: p2)
        game.addPlayer(player: p3)
        
        if game.actualPlayerSize != 3 {
            self.pr.write("actualPlayerSize is not equal to 3. It is \(game.actualPlayerSize)")
        }
        
        
        if game.players.count != 3 {
            self.pr.write("Player list is not equal to 3")
        }
        
        assert(1 == 1)  // runs (not failure)
        
        
        assert(game.players.contains(where: {$0.id == p1.id}))
        
        
        assert(game.players.contains(where: {$0.id == p2.id}))
        assert(game.players.contains(where: {$0.id == p3.id}))
        
        
        
        game.addPlayer(player: p4)
        game.addPlayer(player: p5)
        game.addPlayer(player: p6)
        game.addPlayer(player: p7)
        
        assert(game.actualPlayerSize == 7)
        assert(game.actualPlayerSize == 7)
        assert(game.players.count == 7)
        
        var p8 = Player(id: UUID().uuidString)
        game.addPlayer(player: p8)
        
        assert(!game.players.contains(where: {$0.id == p8.id}))
        
        

//
//        var p9 = Player(id: UUID())
//        var p10 = Player(id: UUID())
//
//
//        var lobby = Lobby(host: p1.id, [p8, p9, p10])
//
//
//
//
        
        
        
        testPassed = true
        
    }
    
    
}
