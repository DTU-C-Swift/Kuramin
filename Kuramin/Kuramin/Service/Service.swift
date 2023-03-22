//
//  Service.swift
//  Kuramin
//
//  Created by MD. Zahed on 01/03/2023.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

//import FirebaseCore
//import FirebaseFirestore
import Firebase

import FirebaseAuth
import FirebaseStorage


class Service {
    private var db = Firestore.firestore()
    private let storage = Storage.storage()
    private let printer = Printer(tag: "Service", displayPrints: true)
    
    var LOBBY = "lobby"
    var MATCHES = "matches"
    
    // var lobbyDocRef = Firestore.firestore().collection("matches").document("lobby")
    
    let NOTSET = Util.NOT_SET
    
    var previousLobby: FirstLobby = FirstLobby(host: "", playerIds: [""])
    var isLobbyObserving = false
    
    
    
    
    
    
    
    
    
    
    
    //-------------------------------- New implementation of lobby -----------------------------//
    
    func goToLobby(me: Player, controller: Controller, shouldCall_lobbyObserver: Bool) {
        let game = controller.game
        
        let dbPlayerNullable = DbPlayerNullable(pName: me.fullName, pid: me.id, randomNum: me.randomNumber, cardsInHand: me.cardsInHand)
        
        let docRef = db.collection(MATCHES).document(LOBBY)
        
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
                
                let gameId = String(UUID().uuidString.prefix(10))
                
                let dbLobby = DbLobbyNullable(gameId: gameId, host: Util.NOT_SET, whoseTurn: Util.NOT_SET, players: [dbPlayerNullable])
                
                do {
                    try transaction.setData(from: dbLobby, forDocument: docRef)
                    
                } catch {
                    self.printer.write("Error while setting dbLobby data")
                }
                
            }
            
            // <---------  Player is in the lobby already -------------->
            else {
                
                
                // Checks If the player already exists in the lobby(player list).
                
                do {
                    let dbLobbyNullable = try lobbyDocument.data(as: DbLobbyNullable.self)
                    
                    
                    if let dbLobby = dbLobbyNullable.mapToLobby() {
                        
                        for crrP in dbLobby.players {
                            if crrP.pid == me.id {
                                me.setCardsInHand(cardInHad: crrP.cardsInHand)
                                me.setRandomNum(randNum: crrP.randomNum)
                                self.printer.write("You were already in the lobby. cardInHand: \(me.cardsInHand), gameId: \(controller.game.id)")
                                return
                            }
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
                self.printer.write("You successfully landed in lobby. Id: \(me.id)")
                //                self.amIHost(game: game)
                
                if shouldCall_lobbyObserver {
                    self.observeLobby(game: game, controller.onSuccessLobbySnapshot(lobby:))
                }
                
                
                //self.observeLobby(game: game, controller.onSuccessLobbySnapshot(lobby:))
                
            }
        }
        
        
        
        
        
    }
    
    var obsRef: ListenerRegistration? = nil
    
    func observeLobby(game: Game, _ onSuccess: @escaping (Lobby) -> Void) {
        if isLobbyObserving {
            obsRef?.remove()
            printer.write("Lobby observer removed.")
        }
        
        let docRef = db.collection(MATCHES).document(LOBBY)
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
        
        let docRef = db.collection(MATCHES).document(LOBBY)
        
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
        
        let docRef = db.collection(MATCHES).document(LOBBY)
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

        let docRef = db.collection(MATCHES).document(LOBBY)
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
    
    
    
    
    
    
    
    func exitLobby() {
        
        
        
        
        
    }
    
    
    
    
    // ----------------------------------------------- //
    
    
    
    
    func create_or_update_user(userImage: UIImage?, game: Game) {
        
        if userImage == nil {
            self.printer.write("Image is nil")
            self.logOut()
            return
            
        }
        // TODO check if the user is already exist in the db
        
        
        if let user = Auth.auth().currentUser {
            var dbUser = DbUser(uid: user.uid, fullName: user.displayName ?? "", coins: 500)
            
            game.me.setId(pid: user.uid)
            
            
            let userRef = db.collection("users").document(user.uid)
            
            userRef.getDocument { document, err in
                
                if let document = document, document.exists {
                    if let coins = document.data()?["coins"] as? Int {
                        self.printer.write("User already exits in the db")
                        dbUser.coins = coins
                        
                    }
                    
                }
                
                self.createUser(dbUser, userImage!)
                
                
            }
        }
        
    }
    
    
    
    
    private func createUser(_ dbUser: DbUser, _ userImage: UIImage) {
        
        if let uid = dbUser.uid {
            
            do {
                try db.collection("users").document(uid).setData(from: dbUser)
                
            } catch let error {
                self.printer.write("Error creating user in db: \(error)")
            }
            
            uploadImg(userId: uid, img: userImage)
            
        } else {
            self.printer.write("User in nil")
            self.logOut()
        }
        
        
    }
    
    
    
    
    
    
    private func uploadImg(userId: String, img: UIImage) {
        guard let imageData = img.jpegData(compressionQuality: 0.8) else {
            //self.logOut()
            self.printer.write("Error converting image")
            return
        }
        
        let path = storage.reference().child("images").child(userId)
        let filename = "\(userId).jpg"
        let imageRef = path.child(filename)
        
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                self.printer.write("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            self.printer.write("Image uploaded successfully!")
        }
        
    }
    
    
    
    
    
    func observeMeInDB(game: Game) {
        let me = game.me
        
        if me.id == Util.NOT_SET {
            
            if let user = Auth.auth().currentUser {
                me.setId(pid: user.uid)
            }
        }
        
        
        
        
        // Gets user image from storage
        self.downloadImg(player: me)
        
        
        
        // Gets user from firestore
        db.collection("users").document(me.id).addSnapshotListener { snapshot, error in
            guard let document = snapshot else {
                self.printer.write("Error fetching document: \(error!)")
                
                return
            }
            guard let data = document.data() else {
                self.printer.write("Document data was empty.")
                return
            }
            
            do {
                let dbUser = try document.data(as: DbUser.self)
                self.printer.write("Retrieved user: \(dbUser.toString())")
                me.updateMe(dbUser: dbUser)
                
            }
            catch{
                self.printer.write("getUser failed: \(data)")
                
            }
            
            
        }
        
        
    }
    
    
    
    // Downloads the profile picture of the given player and sets the fetched picture to the given player.
    
    func downloadImg(player: Player) {
        printer.write("DownloadImg being called. \(player.id)")
        let path = storage.reference().child("images").child(player.id)
        let filename = "\(player.id).jpg"
        let imageRef = path.child(filename)
        imageRef.getData(maxSize: 1 * 100 * 100) { data, error in
            if let error = error {
                self.printer.write("Error occured while fetching imge for UID: \(player.id), error: \(error)")
                
            }
            else {
                if let img = UIImage(data: data!) {
                    
                    player.setStrImg(img: img)
                    
                    //                    if shouldAddPlayerToGame {
                    //                        game.addNode(nodeToAdd: player)
                    //                        self.printer.write("Player added \(player.fullName), \(player.id)")
                    //                    }
                    return
                }
                self.printer.write("Error in converting image")
                
            }
        }
        
    }
    
    

    
    func isUserloggedIn_viaFacebook() -> Bool {
        
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                if userInfo.providerID == "facebook.com" {
                    self.printer.write("Provider: \(userInfo.providerID)")
                    return true
                }
            }
        }
        
        
        return false
    }
    
    
    
    func logOut() {
        if self.isUserloggedIn_viaFacebook() {
            login().logOutFb()
        }
        
        do {
            try Auth.auth().signOut()
            
        } catch {
            self.printer.write("Error while signing out from firebase")
        }
        
        
    }
    
    
    
    func deleteLobby() {
        let docRef = db.collection(MATCHES).document(LOBBY)
        
        docRef.delete() { err in
            
            if err != nil {
                self.printer.write("Error deleting lobby. Cause: \(err.debugDescription)")
                
            } else {
                self.printer.write("Lobby successfully deleted")
                
            }
            
        }
    }
    
    
    func setLobbyDocumentRef(collStr: String, path: String) {
        
        if collStr.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            path.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        
        self.MATCHES = collStr
        self.LOBBY = path
        
        self.printer.write("lobby document reference changed")
    }
    
    
}
