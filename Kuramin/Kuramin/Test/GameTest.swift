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
    
    
    
    func tests() {
        let game = controller.game
        addPlayerTest_beforeGame_starts()
        addPlayerTest_AfterGame_starts()
     
        
        testPassed = true
        
    }
    
    
    
    
    
    func addPlayerTest_beforeGame_starts() {
        let game = Game()
        
        let p1 = Player(id: "p1")
        let p2 = Player(id: "p2")
        let p3 = Player(id: "p3")
        let p4 = Player(id: "p4")
        let p5 = Player(id: "p5")
        let p6 = Player(id: "p6")
        let p7 = Player(id: "p7")
        
        
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
        
        
        game.addPlayer(player: p1)
        assert(game.players.count == 3)

        
        
        
        game.addPlayer(player: p4)
        game.addPlayer(player: p5)
        game.addPlayer(player: p6)
        game.addPlayer(player: p7)
        
        assert(game.actualPlayerSize == 7)
        assert(game.players.count == 7)
        
        let p8 = Player(id: "p8")
        game.addPlayer(player: p8)
        
        assert(!game.players.contains(where: {$0.id == p8.id}))
        
        


        let p9 = Player(id: "p9")
        let p10 = Player(id: "p10")


        var lobby = Lobby(host: p8.id, playerIds: [p8.id, p9.id, p10.id])
        
        game.updatePlayerList(lobby: &lobby)
        
        assert(game.actualPlayerSize == 0)
        assert(game.players.count == 0)

        
        game.addPlayer(player: p8)
        assert(game.players.contains(where: {$0.id == p8.id}))

    }
    
    
    
    
    func addPlayerTest_AfterGame_starts() {
        let game = Game()
        
        let p1 = Player(id: "p1")
        let p2 = Player(id: "p2")
        let p3 = Player(id: "p3")
        let p4 = Player(id: "p4")
        let p5 = Player(id: "p5")
        let p6 = Player(id: "p6")
        let p7 = Player(id: "p7")
        
        
        game.addPlayer(player: p1)
        game.addPlayer(player: p2)
        game.addPlayer(player: p3)
        game.addPlayer(player: p4)
        game.addPlayer(player: p5)
        game.addPlayer(player: p6)
        game.addPlayer(player: p7)
        
        game.isGameStarted = true
        
        
        let p8 = Player(id: "p8")
        let p9 = Player(id: "p9")
        let p10 = Player(id: "p10")


        // Updated the player list and the lobby it self
        var lobby = Lobby(host: p8.id, playerIds: [p7.id, p8.id, p9.id, p10.id])
        game.updatePlayerList(lobby: &lobby)
        
        assert(game.actualPlayerSize == 1)
        assert(game.players[6].id == p7.id)
        assert(game.players.count == 7)
        assert(lobby.playerIds.count == 3)
        
        assert(game.players[0].isLeft)
        assert(!game.players[0].leftAt.isEmpty)
        assert(game.players[5].isLeft)
        
        /// Adding a new player that replaces one of the earliest players that have left the game
        
        game.addPlayer(player: p8)
        assert(game.players[0].id == p8.id)
        assert(game.actualPlayerSize == 2)
        assert(game.players.count == 7)
        assert(!game.players[0].isLeft)
        assert(!game.players.contains(where: {$0.id == p1.id}))

        
        // Addiing a player that have been added previously and left the game
        assert(game.players[4].isLeft)
        assert(game.players[4].id == p5.id)
        
        game.addPlayer(player: p5)
        assert(game.players[4].id == p5.id)
        assert(!game.players[4].isLeft)
        assert(game.players[4].leftAt.isEmpty)
        assert(game.actualPlayerSize == 3)
        
        
        var counter = 0
        for p in game.players {
            if p.id == p5.id {counter += 1}
        }
        
        assert(counter == 1)
        
        game.addPlayer(player: p1)
        game.addPlayer(player: p2)
        game.addPlayer(player: p3)
        
        
        
        assert(game.actualPlayerSize == 6)
        assert(game.players.count == 7)

        assert(!p1.isLeft)
        assert(!p2.isLeft)
        assert(!p3.isLeft)
        assert(game.players.contains(where: {$0.id == p1.id}))
        assert(game.players.contains(where: {$0.id == p2.id}))
        assert(game.players.contains(where: {$0.id == p3.id}))

        game.addPlayer(player: p4)
        
        assert(game.actualPlayerSize == 7)
        assert(game.players.count == 7)
        


        
    }
    
    
    
    func test_to_check_if_correct_player_is_replaced() {
        let game = Game()
        
        let p1 = Player(id: "p1")
        p1.displayName = p1.id
        let p2 = Player(id: "p2")
        p2.displayName = p2.id
        let p3 = Player(id: "p3")
        p3.displayName = p3.id
        let p4 = Player(id: "p4")
        p4.displayName = p4.id
        let p5 = Player(id: "p5")
        p5.displayName = p5.id
        let p6 = Player(id: "p6")
        p6.displayName = p6.id
        let p7 = Player(id: "p7")
        p7.displayName = p7.id

        
        game.isGameStarted = true
        
        game.addPlayer(player: p1)
        game.addPlayer(player: p2)
        game.addPlayer(player: p3)
        game.addPlayer(player: p4)
        game.addPlayer(player: p5)
        game.addPlayer(player: p6)
        game.addPlayer(player: p7)
        
        
        
        assert(game.players[4].id == p5.id)
        // p5 is removed by this call
        var lobby = Lobby(host: p6.id, playerIds: [p6.id, p4.id, p1.id, p7.id, p3.id, p2.id])

        
        assert(game.players[4].id == p5.id)
        assert(game.players[4].isLeft && !game.players[4].leftAt.isEmpty)

        assert(game.actualPlayerSize == 6)
        assert(game.players.count == 7)
        
        // => p5 (players[4]) was removed from the previous actions
        
        assert(game.players[0].id == p1.id)
        assert(game.players[1].id == p2.id)
        assert(game.players[2].id == p3.id)
        assert(game.players[3].id == p4.id)

        assert(game.players[5].id == p6.id)
        assert(game.players[6].id == p7.id)




        
        
        
        
        lobby = Lobby(host: p6.id, playerIds: [p6.id, p4.id, p1.id, p7.id, p3.id, p2.id])

        
    }
    
    
}
