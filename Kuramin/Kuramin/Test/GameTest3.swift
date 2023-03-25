//
//  GameTest3.swift
//  Kuramin
//
//  Created by MD. Zahed on 25/03/2023.
//

import Foundation
import Dispatch

class GameTest3 : ObservableObject {
    
    let p = Printer(tag: "GameTest3", displayPrints: true)
    @Published var testPassed: Bool = false
    var thread: ThreadOtherPlayer?
    
    

    
    
    func run() {
        thread = ThreadOtherPlayer()
        thread!.start()
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
//            self.thread_me()
//        }
        
    }
    

    
    
    func thread_me() {
        p.write("Me starting")
        
        let controller = Controller()
        let game = controller.game
        let lobbyService = controller.lobbyService
        controller.lobbyService.setMatchPath(collStr: "test")

        assert(game.me.id == Util.NOT_SET)

        controller.observeMeInDB()
        lobbyService.deleteLobby()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            assert(game.me.id != Util.NOT_SET)
            assert(game.me.fullName != Util.NOT_SET)
            
            
            controller.goToLobby()
            

            DispatchQueue.main.asyncAfter(deadline:  .now() + 3) {
                
                assert(game.playerSize == 2)
                assert(game.hostId == Util.NOT_SET)
                assert(game.head!.randomNumber < game.head!.nextPlayer!.randomNumber)
                assert(game.head!.id == game.me.id)

                DispatchQueue.main.asyncAfter(deadline:  .now() + lobbyService.waitTimeSec) {
                
                    self.gameInitializationTest(controller: controller, game: game, lobbyService: lobbyService)
                }
                
            }

        }
        
        
    }
    
    
    
    func gameInitializationTest(controller: Controller, game: Game, lobbyService: LobbyService) {
        
        assert(game.id == lobbyService.MATCH_ID)
        
        assert(game.hostId == "testId1")
        assert(game.head!.cards.count == 4)
        assert(game.head!.nextPlayer!.cards.count == 4)

        if thread!.testPassed {
            self.testPassed = true
        }
        

    }
}





//DispatchQueue.main.asyncAfter(deadline:  .now() + 3) {
//
//}
