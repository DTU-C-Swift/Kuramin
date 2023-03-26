//
//  Service.swift
//  Kuramin
//
//  Created by MD. Zahed on 01/03/2023.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import Firebase

import FirebaseAuth
import FirebaseStorage


class UserService {
    private var db = Firestore.firestore()
    private let storage = Storage.storage()
    private let printer = Printer(tag: "UserService", displayPrints: true)
    


    let NOTSET = Util.NOT_SET
        
    
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
        
        _ = imageRef.putData(imageData, metadata: metadata) { metadata, error in
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
    
    

    
    

    
    
}
