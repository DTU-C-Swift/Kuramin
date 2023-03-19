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

    let lobbyStr = "lobby"
    var previousLobby: FirstLobby = FirstLobby(host: "", playerIds: [""])
    var isLobbyObserving = false

    
    
    
    
    
    
    
    
    
    
    //-------------------------------- New implementation of lobby -----------------------------//
    
    func goToLobby(me: Player, controller: Controller) {
        let game = controller.game
        let ref = db.collection("matches").document(lobbyStr)
        
        let dbPlayerNullable = DbPlayerNullable(pName: me.fullName, pid: me.id, randomNum: me.randomNumber, cardsInHand: me.cardsInHand)


        // Transactional call
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let lobbyDocument: DocumentSnapshot
            
            do {
                lobbyDocument = try transaction.getDocument(ref)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }


            // Checks if document "lobby" exists already in db
            if !lobbyDocument.exists {
                self.printer.write("Document in lobby does not exit")
                
                let gameId = String(UUID().uuidString.prefix(10))
                
                let dbLobby = DbLobbyNullable(gameId: gameId, host: Util().NOT_SET, whoseTurn: Util().NOT_SET, players: [dbPlayerNullable])

                do {
                    try transaction.setData(from: dbLobby, forDocument: ref)

                } catch {
                    self.printer.write("Error while setting dbLobby data")
                }
                
            } else {
                

                // Checks If the player already exists in the lobby(player list).
                
                do {
                    let dbLobbyNullable = try lobbyDocument.data(as: DbLobbyNullable.self)
                    
                    
                    if let dbLobby = dbLobbyNullable.mapToLobby() {
                        
                        for crrId in dbLobby.players {
                            if crrId.pid == me.id {
                                self.printer.write("You were already in the lobby")
                                return
                            }
                        }
                    }
                    
                    
                                    
                    
                } catch {
                    self.printer.write("Error while mapping data. (*)")
                }

                
                // If the player does not exists in the lobby(player list) then adds the player to the lobby.
                
                transaction.updateData(["players": FieldValue.arrayUnion([dbPlayerNullable.toDictionary()])], forDocument: ref)

                
            }

            return nil

        }) { (object, error) in
            if let error = error {
                self.printer.write("Failed to go to lobby: \(error)")
            } else {
                self.printer.write("You successfully landed in lobby!")
//                self.amIHost(game: game)
                self.observeLobby(game: game, controller.onSuccessLobbySnapshot(lobby:))
            }
        }





    }
    
    
    func observeLobby(game: Game, _ onSuccess: @escaping (Lobby) -> Void) {
        if isLobbyObserving {
            return
        }
        
        let ref = db.collection("matches").document(lobbyStr)
        
        let obsRef = ref.addSnapshotListener { snapshot, err in
            
            do {
                if let dbLobbyNullable = try snapshot?.data(as: DbLobbyNullable.self) {
                    
                    guard let lobby = dbLobbyNullable.mapToLobby() else {
                        self.printer.write("mapToLobby returned nil")
                        return
                    }
                    
                    onSuccess(lobby)
                    
                    
                }
            }
            
            catch {
                
                self.printer.write("Error in observing lobby. \(err)")
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // ----------------------------------------------- //
    
    
    
    
    
    
    
    
    
    
    func create_or_update_user(userImage: UIImage?) {
        let game = DataHolder.controller.game

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
    
    
    
    
    func createUser(_ dbUser: DbUser, _ userImage: UIImage) {
        
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
    
    
    
    
    
    func observeMeInDB() {
        let game = DataHolder.controller.game
        let me = game.me
        
        if me.id == Util().NOT_SET {
            
            if let user = Auth.auth().currentUser {
                me.setId(pid: user.uid)
            }
        }
        
        

        
        // Gets user image from storage
        self.downloadImg(player: me, shouldAddPlayerToGame: false, game: game)
        
        
        
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
    
    func downloadImg(player: Player, shouldAddPlayerToGame: Bool, game: Game) {
        
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
                                        
                    if shouldAddPlayerToGame {
                        game.addNode(nodeToAdd: player)
                        self.printer.write("Player added \(player.fullName), \(player.id)")
                    }
                    return
                }
                self.printer.write("Error in converting image")

            }
        }
        
    }
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //------------------------------------------ Old implementation of lobby ---------------------------------//
    


//    func amIHost(game: Game) {
//        let me = game.me
//
//        let ref = db.collection("matchMaker").document(lobbyStr)
//        ref.getDocument { document, err in
//
//            if let document = document, document.exists {
//                if let hostId = document.get("host") as? String {
//
//                    game.hostId = hostId
//
//                    if hostId == me.id {
//                        self.printer.write("You are the host")
//
//
//                    } else {
//                        self.printer.write("You aren't the host")
//                    }
//
//                }
//            }
//
//            else {
//                self.printer.write("Document not found in lobby")
//            }
//        }
//
//
//    }
//
//
//    func observeLobby(game: Game) {
//
//        let ref = db.collection("matchMaker").document(lobbyStr)
//
//        ref.addSnapshotListener { snapshot, err in
//
//            do {
//                if var lobby = try snapshot?.data(as: FirstLobby.self) {
//
//                    self.lobbyLock.lock()
//                    if Util().isDuplicateLobby(lobby1: self.previousLobby, lobby2: lobby) {
//                        self.lobbyLock.unlock()
//                        return
//                    }
//
//
//
//
//
//                    Util().deleteEmptyIds(lobby: &lobby)
//
//                    game.updatePlayerList(lobby: &lobby)
//
//
//                    for uid in lobby.playerIds {
//                        self.printer.write("observeLobby: id: \(uid)")
//
//                        self.fetchUser(uid: uid, game: game)
//
//                    }
//
//                    self.lobbyLock.unlock()
//                }
//            }
//            catch {
//
//                self.printer.write("Error in observing lobby. \(err!)")
//            }
//
//
//        }
//
//    }
    
    
    
    
    
//    func fetchUser(uid: String, game: Game) {
//
//        let newPlayer = Player(id: uid)
//
//        self.downloadImg(player: newPlayer)
//
//
//        db.collection("users").document(uid).getDocument(as: DbUser.self) { result in
//
//            switch result {
//            case .success(let dbUser):
//                Util().convertDbuserToPlayer(dbUser: dbUser, player: newPlayer)
//
//                game.addPlayer(player: newPlayer)
//                self.printer.write("User info has been fetched. id: \(newPlayer.id)")
//            case .failure(let err):
//                self.printer.write("Error while fetching user info of id: \(uid).\n Error type: \(err)")
//
//            }
//
//        }
//    }
    
    
    
    
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
    
    
    


    
    

    
    
}
