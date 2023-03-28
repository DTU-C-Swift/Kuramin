//
//  SubService.swift
//  Kuramin
//
//  Created by MD. Zahed on 23/03/2023.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase



class LobbyService : UserService {
    
    private let db = Firestore.firestore()
    private let printer = Printer(tag: "LobbyService", displayPrints: true)
    var waitTimeSec = 20.0
    private (set) var DOC_PATH = "lobby"
    private (set) var COLL_PATH = "matches"
    var previousLobbyNullable: DbLobbyNullable?
    var isLobbyObserving = false

    
    var lobbyObsRef: ListenerRegistration? = nil
    var isObservingLobbyFirstTime = true
    var hasObserverHelperBeenCalled = false
    let semephoreOberservLobby = DispatchSemaphore(value: 1)
    var lobbySnapsot: DocumentSnapshot?

    
    
    
    //-------------------------------- New implementation of lobby -----------------------------//
    
    func goToLobby(me: Player, controller: Controller, shouldCall_lobbyObserver: Bool) {
        var isSucceded = true
        let game = controller.game
        game.setIsWaitingToLandInLobby(val: true)
        let dbPlayerNullable = DbPlayerNullable(pName: me.fullName, pid: me.id, randomNum: me.randomNumber,
                                                cards: me.getCardsInStr())
        
        let docRef = db.collection(COLL_PATH).document(DOC_PATH)
        
        // Transactional call
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let lobbyDocument: DocumentSnapshot
            
            do {
                lobbyDocument = try transaction.getDocument(docRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            
            // Checks if document "lobby" exists already in db
            if !lobbyDocument.exists {
                self.printer.write("Document in lobby does not exit")
                
                //let gameId = String(UUID().uuidString.prefix(15))
                
                let dbLobby = DbLobbyNullable(gameId: Util.NOT_SET, hostId: Util.NOT_SET, whoseTurn: Util.NOT_SET, players: [dbPlayerNullable], cardOnBoard: "")
                
                do {
                    try transaction.setData(from: dbLobby, forDocument: docRef)
                    
                } catch {
                    self.printer.write("Error while setting dbLobby data")
                }
                
            }
            
            // <---------  Player is in the lobby already -------------->
            else {
                
                
                do {
                    let dbLobbyNullable = try lobbyDocument.data(as: DbLobbyNullable.self)
                    
                    if let dbLobby = dbLobbyNullable.mapToLobby() {
                        
                        // Checks If the player already exists in the lobby(player list).
                        for crrP in dbLobby.players {
                            if crrP.pid == me.id {
                                
                                me.setRandomNum(randNum: crrP.randomNum)
                                self.printer.write("You were already in the lobby. gameId: \(controller.game.id)")
                                return
                            }
                        }
                        
                        // Checks If there are already 8 players.
                        if dbLobby.players.count >= 8 {
                            self.printer.write("You need to wait, there are 8 players in lobby")
                            //                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            //                                self.goToLobby(me: me, controller: controller, shouldCall_lobbyObserver: shouldCall_lobbyObserver)
                            //                            }
                            game.setIsWaitingToLandInLobby(val: false)
                            isSucceded = false
                            return
                        }
                    }
                    
                    
                } catch {
                    self.printer.write("Error while mapping data. (*)")
                }
                
                // If the player does not exists in the lobby(player list) then adds the player to the lobby.
                transaction.updateData(["players": FieldValue.arrayUnion([dbPlayerNullable.toDictionary()])], forDocument: docRef)
                
            }
            
            return nil
            
        }) { (object, error) in
            if let error = error {
                self.printer.write("Failed to go to lobby: \(error)")
            } else {
                self.printer.write("Transitional call successfully done")
                
                if isSucceded {
                    self.printer.write("You successfully landed in lobby. Id: \(me.id)")
                    if shouldCall_lobbyObserver {
                        self.observeLobby(game: game, controller.onSuccessLobbySnapshot(lobby:))
                    }
                }
                
            }
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    

    
    
    func observeLobby(game: Game, _ onSuccess: @escaping (Lobby) -> Void) {
        if isLobbyObserving {
            assert(lobbyObsRef != nil)
            lobbyObsRef!.remove()
            printer.write("Lobby observer removed.")
        }
        
        let docRef = db.collection(COLL_PATH).document(DOC_PATH)
        self.printer.write("Observing \(docRef.path) ...")
        isLobbyObserving = true
        
        
        lobbyObsRef = docRef.addSnapshotListener { [self] snapshot, err in
            
            
            guard let snapshot = snapshot, snapshot.exists else {
                self.printer.write("Document(observeLobby) does not exist")
                return
            }
            
            
            lobbySnapsot = snapshot
            
            
            if self.isObservingLobbyFirstTime {
                
                if !hasObserverHelperBeenCalled {
                    hasObserverHelperBeenCalled = true
                    
                    DispatchQueue.global().async {
                        self.wait_for_repeated_snapshot(game: game, onSuccess)
                    }
                    
                }
                
                
            } else {
                
                self.callOnSuccessMethod(game: game, onSuccess)
            }
            
            self.printer.write("Snapshot triggered")
        }
        
    }
    
    
    
    
    
    
    
    func wait_for_repeated_snapshot(game: Game, _ onSuccess: @escaping (Lobby) -> Void) {
        printer.write("Function 'wait_for_repeated_snapshot' is being called")
        
        Task {
            try await Task.sleep(nanoseconds: 3_000_000_000)
            self.isObservingLobbyFirstTime = false
            self.hasObserverHelperBeenCalled = false
            callOnSuccessMethod(game: game, onSuccess)
        }
        
    }
    
    
    
    
    
    func callOnSuccessMethod(game: Game, _ onSuccess: @escaping (Lobby) -> Void) {
        printer.write("Function 'callOnSuccessMethod' is being called")
        
        do {
            let dbLobbyNullable = try lobbySnapsot!.data(as: DbLobbyNullable.self)
            
            guard let lobby = dbLobbyNullable.mapToLobby() else {
                self.printer.write("mapToLobby returned nil")
                game.remove_all_players()
                return
            }
            
            printer.write("Function 'callOnSuccessMethod' players: \(lobby.players.count)")
            previousLobbyNullable = dbLobbyNullable
            
            onSuccess(lobby)
            
        }
        
        catch {
            printer.write("Error in mapping to DbLobbyNullable.")
        }
        
    }
    
    
    
    
    
    /// This method first fetch the lobby and then calls "createLobby" method which creates match with a generated id, and then calls "delete" method to delete the existing lobby.
    /// - Note This method must only be called if the player is the host
    
    func changeLobbyName(controller: Controller)  {
        
        let docRef = db.collection(COLL_PATH).document(DOC_PATH)
        
        docRef.getDocument(as: DbLobbyNullable.self) { result in
            
            switch result {
            case .success(let dbLobbyNullable):
                
                self.printer.write("Lobby has been fetched")
                
                self.createLobby(controller: controller, dbLobbyNullable: dbLobbyNullable)
                
                
            case .failure(let err):
                self.printer.write("Error while fetching lobby. Cause: \(err)")
                
            }
            
        }
        
        
    }
    
    
    
    
    
    /// This function first creates a lobby with a generated gameId and then deletes 'lobby'.
    ///
    
    func createLobby(controller: Controller, dbLobbyNullable dl: DbLobbyNullable) {
        
        var dbLobbyNullabeDup = dl
        
        controller.game.deck.setIntialCardToLobby(dbLobby: &dbLobbyNullabeDup)
        
        dbLobbyNullabeDup.whoseTurn = controller.game.me.nextPlayer!.id
        
        let gameId = String(UUID().uuidString.prefix(15))
        
        dbLobbyNullabeDup.gameId = gameId
        dbLobbyNullabeDup.hostId = controller.game.me.id
        
        
        
        
        let docRef = db.collection(COLL_PATH).document(gameId)
        printer.write("createLobby being called. ColRef: \(docRef.path)")
        do {
            try docRef.setData(from: dbLobbyNullabeDup)
            
            printer.write("Lobby created.")
            
            self.updateGameId(controller: controller, newGameId: gameId)
            //controller.isGameInitializing = false
            
        } catch let err {
            printer.write("Error creating lobby. Cause: \(err.localizedDescription)")
        }
        
    }
    
    
    
    
    
    
    func updateGameId(controller: Controller, newGameId: String) {
        
        self.printer.write("'updateGameId' is being called, new gameId \(newGameId)")
        
        let docRef = db.collection(COLL_PATH).document(DOC_PATH)
        
        docRef.updateData(["gameId": newGameId]) { err in
            
            if let err = err {
                print("Error updating game Id: \(err)")
            } else {
                print("Game ID successfully updated. new gameId \(newGameId)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.deleteLobby(controller: controller, docRef: docRef)
                }
                
            }
        }
    }
    
    
    
    
    
    
    func deleteLobby(controller: Controller, docRef: DocumentReference) {
        
        docRef.delete() { err in
            
            if err != nil {
                self.printer.write("Error deleting lobby. Cause: \(err.debugDescription)")
                
            } else {
                self.printer.write("Lobby successfully deleted")
                
            }
            
            controller.isGameInitializing = false
        }
    }
    
    
    
    
    
    
    
    
    func exitLobby(game: Game, player: Player) {
        let docRef = db.collection(COLL_PATH).document(DOC_PATH)
        
        let playerToRemove = DbPlayerNullable(pName: player.fullName, pid: player.id, randomNum: player.randomNumber, cards: player.getCardsInStr()).toDictionary()
        
        if game.hostId != NOTSET && game.hostId == game.me.id {
            let updateHostId = ["hostId": NOTSET]
            docRef.updateData(updateHostId) { err in
                if let err = err {
                    print("Error setting hostId: \(err.localizedDescription)")
                }
            }
            
            
        }
        
        let updateData = ["players": FieldValue.arrayRemove([playerToRemove])]
        docRef.updateData(updateData) { error in
            if let error = error {
                print("Error removing player from array: \(error.localizedDescription)")
            } else {
                print("Player removed from array successfully.")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func deleteLobby() {
        let docRef = db.collection(COLL_PATH).document(DOC_PATH)
        
        docRef.delete() { err in
            
            if err != nil {
                self.printer.write("Error deleting lobby. Cause: \(err.debugDescription)")
                
            } else {
                self.printer.write("Lobby successfully deleted")
                
            }
            
        }
    }
    
    
    
    
    func setCollectionPath(collStr: String) {
        
        if collStr.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return
        }
        self.COLL_PATH = collStr
        
    }
    
    
    func setDocumentPath(path: String) {
        
        if path.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {return}
        
        if DOC_PATH != path {
            self.DOC_PATH = path
        }
    }
    
    
    
    func updateLobby(lobbyNullable: DbLobbyNullable) {
        
        let docRef = db.collection(COLL_PATH).document(DOC_PATH)
        
        
        do {
            try docRef.setData(from: lobbyNullable, merge: true) { [self]err in
                
                if let err = err {
                    printer.write("Error updating lobby. Cause: \(err.localizedDescription)")
                    
                } else {
                    
                    printer.write("Lobby updated")
                    
                }
                
            }
            
        } catch let err {
            printer.write("Error while mapping lobby. Cause: \(err.localizedDescription)")
        }
        
    }
    
}
