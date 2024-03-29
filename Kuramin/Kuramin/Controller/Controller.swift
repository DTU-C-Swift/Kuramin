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
    var userService = UserService()
    var lobbyService = LobbyService()
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
    let subController = SubController()
    
    
    
    
    
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
        //player.setRandomNum(randNum: 10)
        
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
        lobbyService.lobbyObsRef?.remove()
        lobbyService.observeMeDocRef?.remove()
        lobbyService = LobbyService()
        let oldGame = game
        game = Game()
        game.me.setId(pid: oldGame.me.id)
        game.me.setFullName(fullName: oldGame.me.fullName)
        observeMeInDB()
    }
    
    
    func logOut() {
        userService.logOut()
    }
    
    
    
    
    
    
    
    
    // --------------- This method will be called when a snapshot of observLobby is recieved --------------//
    
    func onSuccessLobbySnapshot(lobby: Lobby) {
        
        
        self.onSuccessLobbyLock.lock()
        
        // TODO compare with previousLobby(not just ids, all the values)
        
        previousLobby = lobby
        
        
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
        
        //-------------------------------//
        game.setHostId(hostId: lobby.hostId)
        game.setPlayerTurnId(pid: lobby.whosTurn)
        
        if let cardOnBoard = lobby.getCardOnBoard() {
            game.setCardOnBoard(card: cardOnBoard)
        }
        
        
        self.onSuccessLobbyLock.unlock()
        
        
        assert(game.id != "" || game.hostId != "")
        assert(lobby.gameId != "" || lobby.hostId != "")
        
        gameInitialization(lobby: lobby)
        
        
    }
    
    
    
    
    func gameInitialization(lobby: Lobby) {
        
        
        if lobby.gameId == Util.NOT_SET {
            
            // Game is not initialized (in lobby).
            
            if lobby.players.count >= 2 && game.head!.prevPlayer!.id == game.me.id {
                initializeGame()
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
                
            }
            
        }
        
        
        
    }
    
    
    
    
    
    
    func initializeGame() {
        p.write("initializeGame is being called")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + lobbyService.waitTimeSec) {
            
            if self.game.playerSize < 2 {
                //self.isGameInitialized = false
                return
            }
            
            
            
            //self.lobbyService.obsRef!.remove()
            
            if self.game.head!.prevPlayer!.id == self.game.me.id {
                
                if self.isGameInitializing { return }
                
                self.isGameInitializing = true
                
                //------------- I am the host -------------//
                self.p.write("You are the host")
                
                self.changeLobbyName()
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
    func send_card_to_next_player (cardIndex: Int) {
        subController.send_card_to_next_player(controller: self, player: game.me , cardIndex: cardIndex)
    }
    
    
    
    
}



