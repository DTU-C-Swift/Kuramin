//
//  GameTest2.swift
//  Kuramin
//
//  Created by MD. Zahed on 18/03/2023.
//

import Foundation

class GameTest2 : ObservableObject {
    @Published var testPassed = false

    
    
    
    init () {
        
    }
    
    
    
    
    
    func test() {
        
        let game = Game()
        

        
        
        
        
        let p1 = Player(id: "p1")
        let p2 = Player(id: "p2")
        let p3 = Player(id: "p3")
        let p4 = Player(id: "p4")
        let p5 = Player(id: "p5")
        let p6 = Player(id: "p6")
        let p7 = Player(id: "p7")
        
        p1.setRandomNum(randNum: 100)
        p2.setRandomNum(randNum: 200)
        p3.setRandomNum(randNum: 300)
        
        p4.setRandomNum(randNum: 400)
        p5.setRandomNum(randNum: 500)
        p6.setRandomNum(randNum: 600)
        p7.setRandomNum(randNum: 700)

        
        // head => nil
        game.addNode(nodeToAdd: p1)
        // Assuming: head => 100
        assert(game.head != nil)
        assert(game.head!.prevPlayer!.id == game.head!.id)
        assert(game.head!.nextPlayer!.id == game.head!.id)
        assert(game.head!.id == p1.id)
        game.printPlayersNode(head: game.head!)
        assert(game.playerSize == 1)

        
        // head => 100
        game.addNode(nodeToAdd: p5)
        // assuming: head => 100, 500
        assert(game.playerSize == 2)
        assert(game.head!.id == p1.id)
        assert(game.head!.nextPlayer!.id == p5.id)
        assert(game.head!.prevPlayer!.id == p5.id)
        
        game.printPlayersNode(head: game.head!)


        
        
        // head => 100, 500
        game.addNode(nodeToAdd: p2)
        // Assuming: head => 100, 200, 500
        
        assert(game.playerSize == 3)
        let headNext = game.head!.nextPlayer
        assert(headNext!.id == p2.id)
        assert(p2.nextPlayer!.id == game.head?.prevPlayer!.id)

        game.printPlayersNode(head: game.head!)


        
        
        // head => 100, 200, 500
        game.addNode(nodeToAdd: p6)
        // Assuming: head => 100, 200, 500, 600
        
        assert(game.playerSize == 4)
        game.printPlayersNode(head: game.head!)

        
        assert(game.head!.prevPlayer!.id == p6.id)


        

        let p_1 = Player(id: "p-1")
        let p_2 = Player(id: "p-2")
        let p_3 = Player(id: "p-3")
        
        testPassed = true

    }
    
    
}
