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
    let userService = UserService()
    let lobbyService = LobbyService()
    @Published var isLoggedIn: Bool = false
    @Published var bufferState: String = ""
    
    //@Published var image: UIImage? = nil
    var dummyPlayerCounter = 1
    let p = Printer(tag: "Controller", displayPrints: true)
    let onSuccessLobbyLock = NSLock()
    var previousLobby: Lobby?
    let NOTSET = Util.NOT_SET
    var isGameInitialized = false
    let gameLogic = GameLogic()
    
    
    
    
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
        player.setCardsInHand(cardInHad: 0)

        if addDummyPlayer {
            lobbyService.goToLobby(me: player, controller:  self, shouldCall_lobbyObserver: false)
        } else {
            lobbyService.goToLobby(me: player, controller:  self, shouldCall_lobbyObserver: true)

        }
        


    }
    
    
    
    
    

    
    
    
    func create_or_update_user(userImage: UIImage?) {
        userService.create_or_update_user(userImage: userImage, game: self.game)
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
        userService.observeMeInDB(game: self.game)
    }
    
    
    
    
    func changeLobbyName() {
        lobbyService.changedLobbyName(controller: self, newName: game.id)
    }
    
    
    
    func exitLobby() {
        lobbyService.exitLobby(game: game, player: game.me)
        
    }
    
    
    func logOut() {
        userService.logOut()
    }
    
    
    
    
    
    func initializeGame() {
        p.write("initializeGame is being called")
        DispatchQueue.main.asyncAfter(deadline: .now() + lobbyService.waitTimeSec) {
            
            if self.game.playerSize < 2 {
                self.isGameInitialized = false
                return
            }
            
            
            
            if self.game.head!.prevPlayer!.id == self.game.me.id {
                // I am the host
                self.p.write("You are the host")
                self.changeLobbyName()
                
            } else {
                // I am not the host
                self.p.write("The host is \(String(describing: self.game.head!.prevPlayer))")
                self.lobbyService.setLobbyDocumentRef(collStr: self.lobbyService.MATCHES, path: self.game.id)
                self.lobbyService.observeLobby(game: self.game, self.onSuccessLobbySnapshot(lobby:))
            }
        }
    }
    
    
    
    
    

    
    
    // --------------- This method will be called when a snapshot of observLobby is recieved --------------//
    
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
                if game.addNode(nodeToAdd: newPlayer) {}
                userService.downloadImg(player: newPlayer)
            }
            
            
            
        }
        
        if game.id == NOTSET {
            game.setGameId(gid: lobby.gameId)
        }
        
        //game.setHostId(hostId: lobby.hostId)
        
        if !game.isLandingInLobbySucceded {
            game.setIsLandingInLobbySucceded(val: true)
        }
        
        
        self.onSuccessLobbyLock.unlock()
        
        
        
        
        if !isGameInitialized {
            if lobby.players.count >= 2 {
                self.initializeGame()
                self.isGameInitialized = true
            }
            
        } else {
            
            if lobby.whosTurn == game.me.id {
                // my turn..
                
                game.setIsMyturn(true)
                
            }
            
        }
        
    }

    
}
