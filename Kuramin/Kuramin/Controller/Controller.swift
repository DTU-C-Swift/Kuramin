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
    var service: UserService = UserService()
    @Published var isLoggedIn: Bool = false
    @Published var bufferState: String = ""
    
    //@Published var image: UIImage? = nil
    var dummyPlayerCounter = 1
    let p = Printer(tag: "Controller", displayPrints: true)
    let onSuccessLobbyLock = NSLock()
    var previousLobby: Lobby?
    let NOTSET = Util.NOT_SET
    var isGameInitialized = false
    var has_host_id_setterMethod_been_called = false
    
    
    
    
    init() {
        self.listenForLogout()
    }
    
    
    
    
    
    func goToLobby(addDummyPlayer: Bool) {

        
        var player = Player(id: "testId\(dummyPlayerCounter)")

        
        
        if addDummyPlayer {
            player.setFullName(fullName: "Name\(dummyPlayerCounter)")
            player.setRandomNum(randNum: dummyPlayerCounter)
            dummyPlayerCounter += 1
        } else {
            
            if game.me.id == NOTSET || game.me.fullName == NOTSET  {
                p.write("Can't go to lobby. Caus: pid: \(game.me.id), fullName: \(game.me.fullName)")
                return
            }
            
            player = game.me
            player.setRandomNum(randNum: Int(arc4random_uniform(10000)))

        }
        
        
        // TODO Needs to find out card size. 20 is just for now
        player.setCardsInHand(cardInHad: Int(arc4random_uniform(15)))

        if addDummyPlayer {
            service.goToLobby(me: player, controller:  self, shouldCall_lobbyObserver: false)
        } else {
            service.goToLobby(me: player, controller:  self, shouldCall_lobbyObserver: true)

        }
        


    }
    
    
    
    
    
    
    func onSuccessLobbySnapshot(lobby: Lobby) {
        
        
        self.onSuccessLobbyLock.lock()
        
        // TODO compare with previousLobby(not just ids, all the values)
        
        
        // Removes player from the display
        game.updatePlayerList(lobby: lobby)
        
        
        
        for crrDbPlayer in lobby.players {
            
            
            
            self.p.write("observeLobby: id: \(crrDbPlayer.pid)")
            
            
            // It is me
            if crrDbPlayer.pid == game.me.id {
                
                self.p.write("It is me")
                game.me.updateInfo(dbPlayer: crrDbPlayer)
                
                if game.addNode(nodeToAdd: game.me) {
                    p.write("Me being added to player list")
                }
                else {p.write("Me being updated")}
                continue
                
                
            } else if let pRef = game.getPlayerRef(pid: crrDbPlayer.pid, shouldLock: true) {
                
                pRef.updateInfo(dbPlayer: crrDbPlayer)
                p.write("Player \(crrDbPlayer.pid) updated")
                
                
            } else {
                
                let newPlayer =  crrDbPlayer.createPlayer()
                game.addNode(nodeToAdd: newPlayer)
                service.downloadImg(player: newPlayer)
            }
            
            
            
        }
        
        if game.id == NOTSET {
            game.setGameId(gid: lobby.gameId)
        }
        
        game.setHostId(hostId: lobby.hostId)
        
        if !game.isLandingInLobbySucceded {
            game.setIsLandingInLobbySucceded(val: true)
        }
        
        
        if !isGameInitialized {
            
            if lobby.players.count > 1 && !has_host_id_setterMethod_been_called {
                service.setHostId_ifIamHost(controller: self)
            }
            
            
            
            if lobby.hostId != Util.NOT_SET {
                
                if lobby.hostId == game.me.id {
                    p.write("You are the host")
                } else {
                    p.write("You are not the host")
                }
            }
                        
        }

        
        self.onSuccessLobbyLock.unlock()
        
    }
    
    
    
    
    func create_or_update_user(userImage: UIImage?) {
        service.create_or_update_user(userImage: userImage, game: self.game)
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
    
    
    
    func observeMeInDB() {
        service.observeMeInDB(game: self.game)
    }
    
    
    
    
    func changeLobbyName() {
        
        
        
        
        service.changedLobbyName(controller: self, newName: game.id)
    }
    
    
    
    func exitLobby() {
        service.exitLobby(game: game, player: game.me)
        
    }
    
    
    

    
}
