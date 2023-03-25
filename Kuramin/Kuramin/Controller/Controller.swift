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
    @Published var profile = Player(id: Util.NOT_SET)
    
    var dummyPlayerCounter = 1
    let p = Printer(tag: "Controller", displayPrints: true)
    let onSuccessLobbyLock = NSLock()
    var previousLobby: Lobby?
    let NOTSET = Util.NOT_SET
    
    var isGameInitializing = false
    //var isGameInitialized = false

    let gameLogic = GameLogic()
    
    
    
    
    
    init() {
        self.listenForLogout()
    }
    
    
    
    
    
    func goToLobby() {
        
        if game.me.id == NOTSET || game.me.fullName == NOTSET  {
            p.write("Can't go to lobby. Caus: pid: \(game.me.id), fullName: \(game.me.fullName)")
            return
        }
        
        let player = game.me
        player.setRandomNum(randNum: Int(arc4random_uniform(10000)))
        //player.setRandomNum(randNum: 10000)
        
        lobbyService.goToLobby(me: player, controller:  self, shouldCall_lobbyObserver: true)
        
    }
    
    
    func addDummyPlayerInLobby() {
        let player = Player(id: "testId\(dummyPlayerCounter)")
        player.setFullName(fullName: "Name\(dummyPlayerCounter)")
        player.setRandomNum(randNum: dummyPlayerCounter)
        dummyPlayerCounter += 1
        
        lobbyService.goToLobby(me: player, controller:  self, shouldCall_lobbyObserver: false)
        
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
        lobbyService.changeLobbyName(controller: self)
    }
    
    
    
    func exitLobby() {
        lobbyService.exitLobby(game: game, player: game.me)
        
    }
    
    
    func logOut() {
        userService.logOut()
    }
    
    
    
    
    
    func initializeGame() {
        p.write("initializeGame is being called")
        
        isGameInitializing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + lobbyService.waitTimeSec) {
            
            if self.game.playerSize < 2 {
                //self.isGameInitialized = false
                self.isGameInitializing = false
                return
            }
            
            //self.lobbyService.obsRef!.remove()
            
            if self.game.head!.prevPlayer!.id == self.game.me.id {
                
                //------------- I am the host -------------//
                self.p.write("You are the host")
                
                self.changeLobbyName()
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
                
                
            } else if let pRef = game.getPlayerRef(pid: crrDbPlayer.pid, shouldLock: true) {
                // Updating an existing player
                
                pRef.updateInfo(dbPlayer: crrDbPlayer)
                p.write("Player \(crrDbPlayer.pid) updated")
                
                
            } else {
                // Creating a new player
                
                let newPlayer =  crrDbPlayer.createPlayer()
                if game.addNode(nodeToAdd: newPlayer) {}
                userService.downloadImg(player: newPlayer)
            }
            
        }
        

        
        
        // Stopping the buffering page
        if !game.isLandingInLobbySucceded {
            game.setIsLandingInLobbySucceded(val: true)
        }
        
        
        self.onSuccessLobbyLock.unlock()
        
        
        assert(game.id != "" || game.hostId != "")
        assert(lobby.gameId != "" || lobby.hostId != "")
        
        
    
        if lobby.gameId == Util.NOT_SET {
            
            // Game is not initialized (in lobby).
            
            if !self.isGameInitializing {
                
                if lobby.players.count >= 2 && game.head!.prevPlayer!.id == game.me.id {
                    self.initializeGame()
                }
                
            }
            

            
        } else {
            // Game is initialized only in lobby or both lobby and local
            
            if game.id == NOTSET {
                // Game is not initialized in local
                lobbyService.setDocumentPath(path: lobby.gameId)
                game.setGameId(gid: lobby.gameId)
                lobbyService.observeLobby(game: game, onSuccessLobbySnapshot(lobby:))

                
            } else {
                
                // Game is initialized both in lobby and local
                game.setHostId(hostId: lobby.hostId)
                game.setPlayerTurnId(pid: lobby.whosTurn)
            }
            
            

            
            

            
        }
        
        

        
        
        
        
        
        
        
        
//        if !isGameInitialized {
//            if lobby.players.count >= 2 {
//                self.initializeGame()
//            }
//
//
//
//        } else {
//
//            // Game is initialized
//            game.setHostId(hostId: lobby.hostId)
//            game.setPlayerTurnId(pid: lobby.whosTurn)
//
//        }
        
    }
    
    
}



//// I am not the host
//self.p.write("The host is \(self.game.head!.prevPlayer!.fullName)")
//self.lobbyService.setMatchId(path: self.game.id)
//
////                DispatchQueue.main.asyncAfter(deadline: .now() + 2)  {
////                    self.lobbyService.observeLobby(game: self.game, self.onSuccessLobbySnapshot(lobby:))
////                }
//
//self.lobbyService.observeLobby(game: self.game, self.onSuccessLobbySnapshot(lobby:))
