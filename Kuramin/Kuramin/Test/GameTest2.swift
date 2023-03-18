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
        
        
        game.addNode(nodeToAdd: p1)
        
        assert(game.head != nil)
        assert(game.tail != nil)
        assert(game.head?.id == game.tail?.id)
        assert(game.playerSize == 1)
        game.printPlayersNode(head: game.head!)


        
        
        testPassed = true

    }
    
    
}
