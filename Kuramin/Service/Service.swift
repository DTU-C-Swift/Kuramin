//
//  Service.swift
//  Kuramin
//
//  Created by MD. Zahed on 01/03/2023.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift


class Service {
    var db = Firestore.firestore()
    let storage = Storage.storage()
    let printer = Printer(tag: "Service", displayPrints: true)
    
    
    
    
    
    func create_or_update_user(userImage: UIImage?) {
        if userImage == nil {
            self.printer.printt("Image is nil")
            self.logOut()
            return
            
        }
        // TODO check if the user is already exist in the db
        
        
        
        
        if let user = Auth.auth().currentUser {
            var dbUser = DbUser(uid: user.uid, fullName: user.displayName ?? "", coins: 500)
            
            
            let userRef = db.collection("users").document(user.uid)
            
            userRef.getDocument { document, err in
                
                if let document = document, document.exists {
                    if let coins = document.data()?["coins"] as? Int {
                        self.printer.printt("User already exits in the db")
                        dbUser.coins = coins
                        
                    }
                    
                }
                
                self.createUser(dbUser, userImage!)
                
                
            }
        }
        
    }
    
    
    
    
    func createUser(_ dbUser: DbUser, _ userImage: UIImage) {
        if let user = Auth.auth().currentUser {
            do {
                try db.collection("users").document(user.uid).setData(from: dbUser)
                
            } catch let error {
                self.printer.printt("Error creating user in db: \(error)")
            }
            
            uploadImg(userId: user.uid, img: userImage)
            
            
        } else {
            self.printer.printt("User in nil")
            self.logOut()
        }
        
    }
    
    
    
    
    
    
    private func uploadImg(userId: String, img: UIImage) {
        
        guard let imageData = img.jpegData(compressionQuality: 0.8) else {
            //self.logOut()
            self.printer.printt("Error converting image")
            return
        }
        
        let path = storage.reference().child("images").child(userId)
        let filename = "\(userId).jpg"
        let imageRef = path.child(filename)
        
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                self.printer.printt("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            self.printer.printt("Image uploaded successfully!")
        }
        
    }
    
    
    
    
    
    func observeForUserChanges(player: Player) {
        
        
        if player.id.isEmpty {
            
            if let user = Auth.auth().currentUser {
                player.id = user.uid
                //uid = "test_uid"
            }
            
        }
        
        
        // Gets user image from storage
        self.downloadImg(player)
        
        
        
        // Gets user from firestore
        db.collection("users").document(player.id).addSnapshotListener { snapshot, error in
            guard let document = snapshot else {
                self.printer.printt("Error fetching document: \(error!)")
                
                return
            }
            guard let data = document.data() else {
                self.printer.printt("Document data was empty.")
                return
            }
            
            do {
                let dbUser = try document.data(as: DbUser.self)
                self.printer.printt("Retrieved user: \(dbUser.toString())")
                player.update(dbUser)
                
            }
            catch{
                self.printer.printt("getUser failed: \(data)")
                
            }
            
            
        }
        
        
    }
    
    
    
    // Downloads the profile picture of the given player and sets the fetched picture to the given player.
    
    func downloadImg(_ player: Player) {
        let uid = player.id
        let path = storage.reference().child("images").child(uid)
        let filename = "\(uid).jpg"
        let imageRef = path.child(filename)
        imageRef.getData(maxSize: 1 * 100 * 100) { data, error in
            if let error = error {
                self.printer.printt("Error occured while fetching imge for UID: \(uid), error: \(error)")
                
            }
            else {
                if let img = UIImage(data: data!) {
                    player.image = img
                }
                
            }
        }
        
    }
    
    
    func goToLobby(player: Player) {
        let ref = db.collection("matches").document("lobby")
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
                transaction.setData(["playerIds": [player.id], "host": player.id], forDocument: ref)
            } else {
                transaction.updateData([
                    "playerIds" : FieldValue.arrayUnion([player.id])
                ], forDocument: ref)
            }
            
            return nil
            
        }) { (object, error) in
            if let error = error {
                self.printer.printt("Transaction failed: \(error)")
            } else {
                self.printer.printt("Transaction succeeded!")
                self.amIHost(player)
            }
        }
    }
    
    
    
    
    
    func amIHost(_ player: Player) {
        var ref = db.collection("matches").document("lobby")
        ref.getDocument { document, err in
            
            if let document = document, document.exists {
                if let host = document.get("host") as? String {
                    
                    if host == player.id {
                        self.printer.printt("You are the host")
                    } else {
                        self.printer.printt("You aren't the host")
                    }
                    
                }
            }
        }
        
        
    }
    
    
    
    
    
    //    func fetchData(){
    //        db.collection("lobby").getDocuments { snapshot, err in
    //
    //            if err == nil {
    //
    //                for it in snapshot!.documents {
    //                    self.printer.printt("\(it.documentID) => \(it.data())")
    //                }
    //
    //            }
    //            else {
    //
    //                self.printer.printt("Error getting documents: \(err)")
    //
    //            }
    //
    //        }
    //
    //    }
    
    
    
    
    func isUserloggedIn_viaFacebook() -> Bool {
        
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                if userInfo.providerID == "facebook.com" {
                    self.printer.printt("Provider: \(userInfo.providerID)")
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
            self.printer.printt("Error while signing out from firebase")
        }
        
        
    }
    
    
}
