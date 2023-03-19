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
    private let lobbyLock = NSLock()

    let lobby = "lobby"
    var previousLobby: Lobby = Lobby(host: "", playerIds: [""])
    
    
    
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
            
            game.me.id = user.uid
            
            
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
        var me = game.me
        
        if me.id == Util().MY_DUMMY_ID {
            
            if let user = Auth.auth().currentUser {
                me.id = user.uid
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
                me.update(dbUser)
                
            }
            catch{
                self.printer.write("getUser failed: \(data)")
                
            }
            
            
        }
        
        
    }
    
    
    
    // Downloads the profile picture of the given player and sets the fetched picture to the given player.
    
    func downloadImg(player: Player) {
        
        let path = storage.reference().child("images").child(player.id)
        let filename = "\(player.id).jpg"
        let imageRef = path.child(filename)
        imageRef.getData(maxSize: 1 * 100 * 100) { data, error in
            if let error = error {
                self.printer.write("Error occured while fetching imge for UID: \(player.id), error: \(error)")
                
            }
            else {
                if let img = UIImage(data: data!) {
                    player.lock.lock()
                    player.image = img
                    player.lock.unlock()
                    //DataHolder.playerGerbage.append(player)
                    //game.setPlayerImg(pid: pid, image: img)
                    return
                }
                self.printer.write("Error in converting image")

            }
        }
        
    }
    
    
    func goToLobby() {
        let game = DataHolder.controller.game
        var me = game.me
        let ref = db.collection("matchMaker").document(lobby)
        //player.id = "testId"
        
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
                transaction.setData(["playerIds": [me.id], "host": me.id], forDocument: ref)
            } else {
                transaction.updateData([
                    "playerIds" : FieldValue.arrayUnion([me.id])
                ], forDocument: ref)
            }
            
            return nil
            
        }) { (object, error) in
            if let error = error {
                self.printer.write("Transaction failed: \(error)")
            } else {
                self.printer.write("Transaction succeeded!")
                self.amIHost(game: game)
                self.observeLobby(game: game)
            }
        }
    }
    
    
    
    
    
    func amIHost(game: Game) {
        var me = game.me
        
        var ref = db.collection("matchMaker").document(lobby)
        ref.getDocument { document, err in
            
            if let document = document, document.exists {
                if let hostId = document.get("host") as? String {
                    
                    game.hostId = hostId
                    
                    if hostId == me.id {
                        self.printer.write("You are the host")
                        

                    } else {
                        self.printer.write("You aren't the host")
                    }
                    
                }
            }
            
            else {
                self.printer.write("Document not found in lobby")
            }
        }
        
        
    }
    

    func observeLobby(game: Game) {
        
        var ref = db.collection("matchMaker").document(lobby)
        
        ref.addSnapshotListener { snapshot, err in
            
            do {
                if var lobby = try snapshot?.data(as: Lobby.self) {
                    
                    self.lobbyLock.lock()
                    if Util().isDuplicateLobby(lobby1: self.previousLobby, lobby2: lobby) {
                        self.lobbyLock.unlock()
                        return
                    }
                    
                    
                    
                    
                    
                    Util().deleteEmptyIds(lobby: &lobby)
                    
                    game.updatePlayerList(lobby: &lobby)
                    
                    
                    for uid in lobby.playerIds {
                        self.printer.write("observeLobby: id: \(uid)")
                        
                        self.fetchUser(uid: uid, game: game)
                        
                    }
                    
                    self.lobbyLock.unlock()
                }
            }
            catch {
                
                self.printer.write("Error in observing lobby. \(err)")
            }
            

        }
        
    }
    
    
    
    
    
    func fetchUser(uid: String, game: Game) {
        
        var newPlayer = Player(id: uid)
        
        self.downloadImg(player: newPlayer)
        
    
        db.collection("users").document(uid).getDocument(as: DbUser.self) { result in
            
            switch result {
            case .success(let dbUser):
                Util().convertDbuserToPlayer(dbUser: dbUser, player: newPlayer)
                
                game.addPlayer(player: newPlayer)
                self.printer.write("User info has been fetched. id: \(newPlayer.id)")
            case .failure(let err):
                self.printer.write("Error while fetching user info of id: \(uid).\n Error type: \(err)")
                
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
    
    
    
//
//    func gotoMatch() {
//
//        let game = DataHolder.controller.game
//        var me = game.me
//        let ref = db.collection("matches").document(lobby)
//
//        var myCards: [DbCard] = [DbCard(suit: "dimonds", value: 10), DbCard(suit: "hearts", value: )]
//
//        var let DbPlayer = DbPlayer(cards: [], nextPid: <#T##String#>, prevPid: <#T##String#>)
//
//
//
//        // Transactional call
//        db.runTransaction({ (transaction, errorPointer) -> Any? in
//            let lobbyDocument: DocumentSnapshot
//            do {
//                lobbyDocument = try transaction.getDocument(ref)
//            } catch let fetchError as NSError {
//                errorPointer?.pointee = fetchError
//                return nil
//            }
//
//
//            // Checks if document "lobby" exists already in db
//            if !lobbyDocument.exists {
//                transaction.setData(["playerIds": [me.id], "host": me.id], forDocument: ref)
//            } else {
//                transaction.updateData([
//                    "playerIds" : FieldValue.arrayUnion([me.id])
//                ], forDocument: ref)
//            }
//
//            return nil
//
//        }) { (object, error) in
//            if let error = error {
//                self.printer.write("Transaction failed: \(error)")
//            } else {
//                self.printer.write("Transaction succeeded!")
//                self.amIHost(game: game)
//                self.observeLobby(game: game)
//            }
//        }
//
//
//
//
//
//    }
    
    
    func observeMatch() {
        
    }
    
    
    
    
}