//
//  GameTest2.swift
//  Kuramin
//
//  Created by MD. Zahed on 18/03/2023.
//

import Foundation

class GameTestMain : ObservableObject {
    @Published var testPassed: Bool = false

    
    
    func main() {

        
//        for i in 0...10 {
//            addAndRemoveMethodsTest()
//            addAndRemoveWithIdMethodsTest()
//            SubGameTest().main()
//        }
        
        
        
        addAndRemoveMethodsTest()
        addAndRemoveWithIdMethodsTest()
        
        testPassed = true
    }
    
    
    
    func addAndRemoveMethodsTest() {
        
        let game = Game()
        
        let p1 = Player(id: "p1")
        let p2 = Player(id: "p2")

        let p5 = Player(id: "p5")
        let p6 = Player(id: "p6")
        let p7 = Player(id: "p7")
        
        p1.setRandomNum(randNum: 100)
        p2.setRandomNum(randNum: 200)
        p5.setRandomNum(randNum: 500)
        p6.setRandomNum(randNum: 600)
        p7.setRandomNum(randNum: 700)

        
        // head => nil
        assert(game.addNode(nodeToAdd: p1))
        // Assuming: head => 100
        assert(game.head != nil)
        assert(game.head!.prevPlayer!.id == game.head!.id)
        assert(game.head!.nextPlayer!.id == game.head!.id)
        assert(game.head!.id == p1.id)
        //game.printPlayersNode(head: game.head!)
        assert(game.playerSize == 1)

        
        // head => 100
        assert(game.addNode(nodeToAdd: p5))
        // assuming: head => 100, 500
        assert(game.playerSize == 2)
        assert(game.head!.id == p1.id)
        assert(game.head!.nextPlayer!.id == p5.id)
        assert(game.head!.prevPlayer!.id == p5.id)
        
        //game.printPlayersNode(head: game.head!)


        
        
        // head => 100, 500
        assert(game.addNode(nodeToAdd: p2))
        // Assuming: head => 100, 200, 500
        
        assert(game.playerSize == 3)
        let headNext = game.head!.nextPlayer
        assert(headNext!.id == p2.id)
        assert(p2.nextPlayer!.id == game.head?.prevPlayer!.id)

        //game.printPlayersNode(head: game.head!)


        
        
        // head => 100, 200, 500
        assert(game.addNode(nodeToAdd: p6))
        // Assuming: head => 100, 200, 500, 600
        
        assert(game.playerSize == 4)
        assert(game.head!.prevPlayer!.id == p6.id)
        assert(game.head!.id == p6.nextPlayer!.id)
        //game.printPlayersNode(head: game.head!)


        

        _ = Player(id: "p-1")
        let p_3 = Player(id: "p-3")
        
        p_3.setRandomNum(randNum: 30)
        
        
        
        // head => 100, 200, 500, 600
        assert(game.addNode(nodeToAdd: p_3))
        // Assuming: head => 30, 100, 200, 500, 600
        
        assert(game.playerSize == 5)
        assert(game.head!.id == p_3.id)
        assert(game.head!.nextPlayer!.randomNumber == 100)
        assert(p6.nextPlayer!.id == p_3.id)
        //game.printPlayersNode(head: game.head!)
        
        
        
        // head => head => 30, 100, 200, 500, 600
        assert(game.addNode(nodeToAdd: p7))
        // Assuming: head => 30, 100, 200, 500, 600, 700
        
        assert(game.playerSize == 6)
        assert(game.head!.prevPlayer!.randomNumber == p7.randomNumber)
        //game.printPlayersNode(head: game.head!)

        
        
        
        let p_2 = Player(id: "p-2")
        p_2.setRandomNum(randNum: 40)

        // head => head => 30, 100, 200, 500, 600, 700
        assert(game.addNode(nodeToAdd: p_2))
        // Assuming: head => 30, 40, 100, 200, 500, 600, 700
        assert(game.playerSize == 7)
        assert(game.head!.nextPlayer!.id == p_2.id)
        //game.printPlayersNode(head: game.head!)

        
        
        
        
        let p3 = Player(id: "p3")
        p3.setRandomNum(randNum: 650)
        
        
        // head => head => 30, 100, 200, 500, 600, 700
        assert(game.addNode(nodeToAdd: p3))

        // Assuming: head => 30, 40, 100, 200, 500, 600, 650, 700
        
        assert(game.playerSize == 8)
        assert(game.head!.prevPlayer!.prevPlayer!.id == p3.id)
        //game.printPlayersNode(head: game.head!)

        
        //game.addNode(nodeToAdd: p3)
        assert(game.isInList(node: p3))
        assert(game.isInList(node: p1))
        assert(game.isInList(node: p2))
        assert(game.isInList(node: p5))
        assert(game.isInList(node: p_3))
        assert(game.isInList(node: p7))


        
        // -----------------  Delete Node -------------------//
        
        // head     =>: 30, 40, 100, 200, 500, 600, 650, 700
        // Expectation: 40, 100, 200, 500, 600, 650, 700

        assert(game.removeNode(pid: game.head!.id, shouldLock: true))
        //game.printPlayersNode(head: game.head!)
        assert(game.head!.id == p_2.id)
        assert(game.playerSize == 7)
        
        
        // head     =>: 40, 100, 200, 500, 600, 650, 700
        // Expectation: 40, 100, 200, 500, 600, 650
        
        assert(game.removeNode(pid: p7.id, shouldLock: true))
        //game.printPlayersNode(head: game.head!)
        assert(game.playerSize == 6)
        assert(game.head!.prevPlayer!.id == p3.id)


        
        
        
        // head     =>: 40, 100, 200, 500, 600, 650
        // Expectation: 40, 100, 200, 500, 650
        
        assert(game.removeNode(pid: p6.id, shouldLock: true))
        game.printPlayersNode(head: game.head!, shouldLock: true)
        assert(game.playerSize == 5)
        assert(game.head!.prevPlayer!.id == p3.id)
        assert(game.head!.id == p_2.id)
        
        
        
        
        // head     =>: 40, 100, 200, 500, 650
        // Expectation: 40, 200, 500, 650
        
        assert(game.removeNode(pid: p1.id, shouldLock: true))
        //game.printPlayersNode(head: game.head!)
        assert(game.playerSize == 4)
        assert(game.head!.nextPlayer!.id == p2.id)
        assert(game.head!.id == p_2.id)
        assert(game.head!.prevPlayer!.id == p3.id)
        assert(game.head!.id == p_2.id)
        
        
        
        
        
        // head     =>: 40, 200, 500, 650
        // Expectation: 40
        assert(game.removeNode(pid: p2.id, shouldLock: true))
        if game.removeNode(pid: p5.id, shouldLock: true){}
        if game.removeNode(pid: p3.id, shouldLock: true) {}
        
        assert(game.playerSize == 1)
        assert(game.head!.id == p_2.id)
        assert(game.head!.id == game.head!.nextPlayer!.id)
        assert(game.head!.id == game.head!.prevPlayer!.id)

        


        // head     =>: 40
        // Expectation: nil
        if game.removeNode(pid: p_2.id, shouldLock: true) {}
        assert(game.head == nil)
        assert(game.playerSize == 0)
        
        
        
        let p9 = Player(id: "p9")
        let p10 = Player(id: "p10")
        
        p9.setRandomNum(randNum: 900)
        p10.setRandomNum(randNum: 1000)
        
        
        // head     =>: nil
        // Expectation: p9/900, p10/1000
        
        if game.addNode(nodeToAdd: p10) {}
        if game.addNode(nodeToAdd: p9) {}
        
        assert(game.head!.id == p9.id)
        assert(game.head!.nextPlayer!.id == p10.id)
        assert(game.playerSize == 2)
        
        
        
        // head     =>: p9/900 (cardInHad: -1), p10/1000
        // Expectation: p9/900, p10/1000
        
        assert(game.head!.cardsInHand == Util.NOTSET_INT)
        let p9Dup = Player(id: "p9")
        p9Dup.setCardsInHand(cardInHad: 10)

        if game.addNode(nodeToAdd: p9Dup) {}
        
        assert(game.head!.cardsInHand == 10)
        assert(game.playerSize == 2)
        
        assert(game.head!.id == p9.id)
        assert(game.head!.nextPlayer!.id == p10.id)
        
        
        

        

    }
    
    
    
    
    func addAndRemoveWithIdMethodsTest() {
        
        let game = Game()
        
        let p1 = Player(id: "p1")
        let p2 = Player(id: "p2")

        let p5 = Player(id: "p5")
        let p6 = Player(id: "p6")
        let p7 = Player(id: "p7")
        
        p1.setRandomNum(randNum: 100)
        p2.setRandomNum(randNum: 200)
        p5.setRandomNum(randNum: 500)
        p6.setRandomNum(randNum: 600)
        p7.setRandomNum(randNum: 700)

        
        // head => nil
        if game.addNode(nodeToAdd: p1) {}
        // Assuming: head => 100
        assert(game.head != nil)
        assert(game.head!.prevPlayer!.id == game.head!.id)
        assert(game.head!.nextPlayer!.id == game.head!.id)
        assert(game.head!.id == p1.id)
        //game.printPlayersNode(head: game.head!)
        assert(game.playerSize == 1)

        
        // head => 100
        if game.addNode(nodeToAdd: p5) {}
        // assuming: head => 100, 500
        assert(game.playerSize == 2)
        assert(game.head!.id == p1.id)
        assert(game.head!.nextPlayer!.id == p5.id)
        assert(game.head!.prevPlayer!.id == p5.id)
        
        //game.printPlayersNode(head: game.head!)


        
        
        // head => 100, 500
        if game.addNode(nodeToAdd: p2) {}
        // Assuming: head => 100, 200, 500
        
        assert(game.playerSize == 3)
        let headNext = game.head!.nextPlayer
        assert(headNext!.id == p2.id)
        assert(p2.nextPlayer!.id == game.head?.prevPlayer!.id)

        //game.printPlayersNode(head: game.head!)


        
        
        // head => 100, 200, 500
        if game.addNode(nodeToAdd: p6) {}
        // Assuming: head => 100, 200, 500, 600
        
        assert(game.playerSize == 4)
        assert(game.head!.prevPlayer!.id == p6.id)
        assert(game.head!.id == p6.nextPlayer!.id)
        //game.printPlayersNode(head: game.head!)


        

        _ = Player(id: "p-1")
        let p_3 = Player(id: "p-3")
        
        p_3.setRandomNum(randNum: 30)
        
        
        
        // head => 100, 200, 500, 600
        if game.addNode(nodeToAdd: p_3) {}
        // Assuming: head => 30, 100, 200, 500, 600
        
        assert(game.playerSize == 5)
        assert(game.head!.id == p_3.id)
        assert(game.head!.nextPlayer!.randomNumber == 100)
        assert(p6.nextPlayer!.id == p_3.id)
        //game.printPlayersNode(head: game.head!)
        
        
        
        // head => head => 30, 100, 200, 500, 600
        if game.addNode(nodeToAdd: p7) {}
        // Assuming: head => 30, 100, 200, 500, 600, 700
        
        assert(game.playerSize == 6)
        assert(game.head!.prevPlayer!.randomNumber == p7.randomNumber)
        //game.printPlayersNode(head: game.head!)

        
        
        
        let p_2 = Player(id: "p-2")
        p_2.setRandomNum(randNum: 40)

        // head => head => 30, 100, 200, 500, 600, 700
        if game.addNode(nodeToAdd: p_2) {}
        // Assuming: head => 30, 40, 100, 200, 500, 600, 700
        assert(game.playerSize == 7)
        assert(game.head!.nextPlayer!.id == p_2.id)
        //game.printPlayersNode(head: game.head!)

        
        
        
        
        let p3 = Player(id: "p3")
        p3.setRandomNum(randNum: 650)
        
        
        // head => head => 30, 100, 200, 500, 600, 700
        if game.addNode(nodeToAdd: p3) {}

        // Assuming: head => 30, 40, 100, 200, 500, 600, 650, 700
        
        assert(game.playerSize == 8)
        assert(game.head!.prevPlayer!.prevPlayer!.id == p3.id)
        //game.printPlayersNode(head: game.head!)

        
        //game.addNode(nodeToAdd: p3)
        assert(game.isInList(node: p3))
        assert(game.isInList(node: p1))
        assert(game.isInList(node: p2))
        assert(game.isInList(node: p5))
        assert(game.isInList(node: p_3))
        assert(game.isInList(node: p7))


        
        // -----------------  Delete Node -------------------//
        
        // head     =>: 30, 40, 100, 200, 500, 600, 650, 700
        // Expectation: 40, 100, 200, 500, 600, 650, 700

        if game.removeNode(pid: game.head!.id, shouldLock: false) {}
        //game.printPlayersNode(head: game.head!)
        assert(game.head!.id == p_2.id)
        assert(game.playerSize == 7)
        
        
        // head     =>: 40, 100, 200, 500, 600, 650, 700
        // Expectation: 40, 100, 200, 500, 600, 650
        
        if game.removeNode(pid: p7.id, shouldLock: false) {}
        //game.printPlayersNode(head: game.head!)
        assert(game.playerSize == 6)
        assert(game.head!.prevPlayer!.id == p3.id)


        
        
        
        // head     =>: 40, 100, 200, 500, 600, 650
        // Expectation: 40, 100, 200, 500, 650
        
        if game.removeNode(pid: p6.id, shouldLock: false) {}
        game.printPlayersNode(head: game.head!, shouldLock: true)
        assert(game.playerSize == 5)
        assert(game.head!.prevPlayer!.id == p3.id)
        assert(game.head!.id == p_2.id)
        
        
        
        
        // head     =>: 40, 100, 200, 500, 650
        // Expectation: 40, 200, 500, 650
        
        if game.removeNode(pid: p1.id, shouldLock: false) {}
        //game.printPlayersNode(head: game.head!)
        assert(game.playerSize == 4)
        assert(game.head!.nextPlayer!.id == p2.id)
        assert(game.head!.id == p_2.id)
        assert(game.head!.prevPlayer!.id == p3.id)
        assert(game.head!.id == p_2.id)
        
        
        
        
        
        // head     =>: 40, 200, 500, 650
        // Expectation: 40
        if game.removeNode(pid: p2.id, shouldLock: false) {}
        if game.removeNode(pid: p5.id, shouldLock: false) {}
        if game.removeNode(pid: p3.id, shouldLock: false) {}
        
        assert(game.playerSize == 1)
        assert(game.head!.id == p_2.id)
        assert(game.head!.id == game.head!.nextPlayer!.id)
        assert(game.head!.id == game.head!.prevPlayer!.id)

        


        // head     =>: 40
        // Expectation: nil
        if game.removeNode(pid: p_2.id, shouldLock: false) {}
        assert(game.head == nil)
        assert(game.playerSize == 0)
        
        
        
        let p9 = Player(id: "p9")
        let p10 = Player(id: "p10")
        
        p9.setRandomNum(randNum: 900)
        p10.setRandomNum(randNum: 1000)
        
        
        // head     =>: nil
        // Expectation: p9/900, p10/1000
        
        if game.addNode(nodeToAdd: p10) {}
        if game.addNode(nodeToAdd: p9) {}
        
        assert(game.head!.id == p9.id)
        assert(game.head!.nextPlayer!.id == p10.id)
        assert(game.playerSize == 2)
        
        
        
        // head     =>: p9/900 (cardInHad: -1), p10/1000
        // Expectation: p9/900, p10/1000
        
        assert(game.head!.cardsInHand == Util.NOTSET_INT)
        let p9Dup = Player(id: "p9")
        p9Dup.setCardsInHand(cardInHad: 10)

        if game.addNode(nodeToAdd: p9Dup) {}
        
        assert(game.head!.cardsInHand == 10)
        assert(game.playerSize == 2)
        
        assert(game.head!.id == p9.id)
        assert(game.head!.nextPlayer!.id == p10.id)
        
        
        
        
        let ref = game.getPlayerRef(pid: p9Dup.id, shouldLock: true)
        assert(ref!.id == p9Dup.id)
        

        

    }

    

    
}
