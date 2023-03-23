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
    private let printer = Printer(tag: "Service", displayPrints: true)
    private let waitTimeSec = 10.0

    
    
    //-------------------------------- New implementation of lobby -----------------------------//
    
    func goToLobby(me: Player, controller: Controller, shouldCall_lobbyObserver: Bool) {
        var isSucceded = true
        let game = controller.game
        game.setIsWaitingToLandInLobby(val: true)
        let dbPlayerNullable = DbPlayerNullable(pName: me.fullName, pid: me.id, randomNum: me.randomNumber, cardsInHand: me.cardsInHand)
        
        let docRef = db.collection(MATCHES).document(MATCH_ID)
        
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
                
                //let gameId = String(UUID().uuidString.prefix(10))
                
                let dbLobby = DbLobbyNullable(gameId: Util.NOT_SET, hostId: Util.NOT_SET, whoseTurn: Util.NOT_SET, players: [dbPlayerNullable])
                
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
                                me.setCardsInHand(cardInHad: crrP.cardsInHand)
                                me.setRandomNum(randNum: crrP.randomNum)
                                self.printer.write("You were already in the lobby. cardInHand: \(me.cardsInHand), gameId: \(controller.game.id)")
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
    
    var obsRef: ListenerRegistration? = nil
    
    func observeLobby(game: Game, _ onSuccess: @escaping (Lobby) -> Void) {
        if isLobbyObserving {
            obsRef?.remove()
            printer.write("Lobby observer removed.")
        }
        
        let docRef = db.collection(MATCHES).document(MATCH_ID)
        self.printer.write("Observing \(docRef.path) ...")
        isLobbyObserving = true
        
        
        obsRef = docRef.addSnapshotListener { snapshot, err in
            
            do {
                if let dbLobbyNullable = try snapshot?.data(as: DbLobbyNullable.self) {
                    
                    guard let lobby = dbLobbyNullable.mapToLobby() else {
                        self.printer.write("mapToLobby returned nil")
                        game.remove_all_players()
                        return
                    }
                    
                    self.printer.write("Snapshot from lobby recieved")
                    onSuccess(lobby)
                    
                    
                }
            }
            
            catch {
                
                self.printer.write("Error in mapping to DbLobbyNullable. \(String(describing: err))")
                
//                if let obsRef = obsRef {
//                    //game.remove_all_players()
//                    obsRef.remove()
//                    self.isLobbyObserving = false
//                    self.printer.write("ObserveLobby removed")
//
//                }
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    func changedLobbyName(controller: Controller, newName: String)  {
        
        
        if newName == NOTSET {
            printer.write("Lobby name can't be changed. Cause: gameId is \(NOTSET)")
            return
        }
        
        let docRef = db.collection(MATCHES).document(MATCH_ID)
        
        docRef.getDocument(as: DbLobbyNullable.self) { result in
            
            switch result {
            case .success(let dbLobbyNullable):
                
                self.printer.write("Lobby has been fetch")
                
                self.delete_and_create_lobby(controller: controller, dbLobbyNullabe: dbLobbyNullable, newName: newName)
                
            case .failure(let err):
                self.printer.write("Error while fetching lobby. Cause: \(err)")
                
            }
            
        }
        
        
    }
    
    
    
    func delete_and_create_lobby(controller: Controller, dbLobbyNullabe: DbLobbyNullable, newName: String) {
        
        let docRef = db.collection(MATCHES).document(MATCH_ID)
        docRef.delete() { err in
            
            if err != nil {
                self.printer.write("Error deleting lobby. Cause: \(err.debugDescription)")
                
            } else {
                self.printer.write("Lobby successfully deleted")
                self.setLobbyDocumentRef(collStr: self.MATCHES, path: newName)

                self.createLobby(controller: controller, dbLobbyNullabe: dbLobbyNullabe)
                
                
            }
            
        }
    }
    
    
    
    
    
    func createLobby(controller: Controller, dbLobbyNullabe: DbLobbyNullable) {

        let docRef = db.collection(MATCHES).document(MATCH_ID)
        printer.write("createLobby being called. ColRef: \(docRef.path)")
        do {
            try docRef.setData(from: dbLobbyNullabe)
            printer.write("Lobby created.")
            
            
            /// Change the document reference

            observeLobby(game: controller.game, controller.onSuccessLobbySnapshot(lobby:))
        } catch let err {
            printer.write("Error creating lobby. Cause: \(err.localizedDescription)")
        }
        
    }
    
    
    
    
    func exitLobby(game: Game, player: Player) {
        let docRef = db.collection(MATCHES).document(MATCH_ID)
        
        let playerToRemove = DbPlayerNullable(pName: player.fullName, pid: player.id, randomNum: player.randomNumber, cardsInHand: player.cardsInHand).toDictionary()
        
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

    
    
    
    
    
    
    
    func setHostId_ifIamHost(controller: Controller) {
        let game = controller.game
        printer.write("setHostId is being called")
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTimeSec) {
            
            if game.playerSize < 2 {
                controller.has_host_id_setterMethod_been_called = false
                return}
            
            
            
            if game.head!.prevPlayer!.id == game.me.id {
                
                
                let docRef = self.db.collection(self.MATCHES).document(self.MATCH_ID)
                                
                docRef.updateData([
                    "hostId": game.me.id
                ]) { err in
                    if let err = err {
                        print("Error updating host Id: \(err)")
                    } else {
                        print("Host ID successfully updated")
                        controller.has_host_id_setterMethod_been_called = true
                        
                    }
                }
                
                
            }
        }
    }
    
    
    
    
    
    
    
}
