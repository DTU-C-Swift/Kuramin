//
//  Controller.swift
//  Kuramin
//
//  Created by MD. Zahed on 01/03/2023.
//

import Foundation
import SwiftUI
import Firebase

class Controller : ObservableObject {
    @Published var game: Game = Game()
    var service: Service = Service()
    @Published var isLoggedIn: Bool = false
    @Published var bufferState: String = ""
    
    //@Published var image: UIImage? = nil
    var dummyPlayerCounter = 1
    let p = Printer(tag: "Controller", displayPrints: true)
    let onSuccessLobbyLock = NSLock()
    var previousLobby: Lobby?
    let notSet = Util().NOT_SET
    
    
    
    
    init() {
        self.listenForLogout()
    }
    
    
    
    
    
    func goToLobby(addDummyPlayer: Bool) {
        
        
        let game = DataHolder.controller.game
        
        var player = Player(id: "testId\(dummyPlayerCounter)")
        
        
        if addDummyPlayer {
            player.setFullName(fullName: "Name\(dummyPlayerCounter)")
            dummyPlayerCounter += 1
        } else {
            
            if game.me.id == notSet || game.me.fullName == notSet  {
                p.write("Can't go to lobby. Caus: pid: \(game.me.id), fullName: \(game.me.fullName)")
                return
            }
            
            player = game.me
            player.setRandomNum(randNum: Int(arc4random_uniform(10000)))
            // TODO Needs to find out card size. 20 is just for now
            player.setCardsInHand(cardInHad: 20)
        }
        

        if addDummyPlayer {
            service.goToLobby(me: player, controller:  self, shouldCall_lobbyObserver: false)
        } else {
            service.goToLobby(me: player, controller:  self, shouldCall_lobbyObserver: true)

        }
        


    }
    
    
    
    
    
    
    func onSuccessLobbySnapshot(lobby: Lobby) {

        self.onSuccessLobbyLock.lock()
        
        if self.previousLobby == nil {
            self.previousLobby = lobby
            
        } else {
            
            if self.previousLobby?.isDuplicateLobby(compareWith: lobby) == true {
                self.onSuccessLobbyLock.unlock()
                return
            }
        }
        
        
        // Removes player from the display
        game.updatePlayerList(lobby: lobby)
        
        
        for crrDbPlayer in lobby.players {
            
            self.p.write("observeLobby: id: \(crrDbPlayer.pid)")
            
            if crrDbPlayer.pid == game.me.id {
                self.p.write("It is me")
                game.me.setRandomNum(randNum: crrDbPlayer.randomNum)
                game.me.setCardsInHand(cardInHad: crrDbPlayer.cardsInHand)
                continue
            }
            
            
            if let crrPlayerRef = game.getPlayerRef(pid: crrDbPlayer.pid) {
                
                if crrPlayerRef.isDefaultImg {
                    service.downloadImg(player: crrPlayerRef, shouldAddPlayerToGame: false, game: game)
                    
                }
                
                crrPlayerRef.updateInfo(dbPlayer: crrDbPlayer)
                
                
            }
            
            else {
                let newPlayer =  crrDbPlayer.createPlayer()
                service.downloadImg(player: newPlayer, shouldAddPlayerToGame: true, game: game)
                
            }
            
            
            
        }
        
        self.onSuccessLobbyLock.unlock()
        
        
        
    }
    
    
    
    
    
    
    func listenForLogout() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.isLoggedIn = false
                print("login false")
                
            }
            else {
                print("login true")
                self.isLoggedIn = true
            }
            
        }
    }
    
}
