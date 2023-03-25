//
//  ThreadOtherPlayer.swift
//  Kuramin
//
//  Created by MD. Zahed on 25/03/2023.
//

import Foundation

class ThreadOtherPlayer : Thread {
    
    let controller = Controller()
    var testPassed: Bool = false
    
    let waitTime1 = 3.0
    let p = Printer(tag: "GameTest3 Thread", displayPrints: true)


    
    

    
    override func main() {
        
        p.write("Thread starting")
        
        
        let game = controller.game
        game.me.setId(pid: "testId1")
        game.me.setFullName(fullName: "Name1")
        game.me.setRandomNum(randNum: 10000)
        
        assert(game.me.id != Util.NOT_SET)
        assert(game.me.fullName != Util.NOT_SET)

        
        
        let lobbyService = controller.lobbyService
        controller.lobbyService.setMatchPath(collStr: "test")
        
        
        
        lobbyService.deleteLobby()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime1) {
            
            //self.controller.goToLobby()
            self.controller.lobbyService.goToLobby(me: game.me, controller: self.controller, shouldCall_lobbyObserver: true)
                                    
            DispatchQueue.main.asyncAfter(deadline:  .now() + self.waitTime1) {
                
                assert(game.playerSize == 1)
                assert(game.hostId == Util.NOT_SET)
                assert(game.head!.id == game.me.id)
                
                self.testPassed = true
                self.p.write("Thread done")

            }
            
            
            
        }
        
            
    }
    
    
}
