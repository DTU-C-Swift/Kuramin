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
    

    
    
    func listenUser(player: Player) {
        
        var uid = ""
        var user = Auth.auth().currentUser
        if let user = user {
            uid = user.uid
            //uid = "test_uid"
        }
        player.id = uid
        // Gets user image from storage
        self.downloadImg(player)
        
        
        
        // Gets user from firestore
        db.collection("users").document(uid).addSnapshotListener { snapshot, error in
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
    


    
    
    func goToLobby(player: Player) {
        let ref = db.collection("matches").document("lobby")
        player.id = "testId"
        
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
                transaction.setData(["playerIds": [player.id]], forDocument: ref)
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
            }
        }
    }

    
    
    

    func amIHost() {
        var ref = db.collection("matches").document("lobby")
        
        
    }
    
    
    
    func fetchData(){
        db.collection("lobby").getDocuments { snapshot, err in
            
            if err == nil {
                
                for it in snapshot!.documents {
                    self.printer.printt("\(it.documentID) => \(it.data())")
                }

            }
            else {
                
                self.printer.printt("Error getting documents: \(err)")
                
            }
            
        }
        
    }
    
    
//    func intializeGame(p: Player) {
//
//        db.collection("lobby").getDocuments { snapshot, err in
//            if snapshot != nil {
//                if snapshot?.count == 0 {
//                    self.goToLobby(player: p)
//                }
//                else {
//                    self.printer.printt("Lobby is not empty")
//                }
//            }
//
//        }
//
//    }
    
    
    
    
    
    
    
    func isUserloggedIn_viaFacebook() -> Bool {
        
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                if userInfo.providerID == "facebook.com" {
                    return true
                }
            }
        }
        
        
        return false
    }
    
    
    
    
    func createUser(userImage: UIImage?) {
        if userImage == nil {return}
        // TODO check if the user is already exist in the db
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            _ = user.uid
            _ = user.email
            _ = user.photoURL
            var multiFactorString = "MultiFactor: "
            for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
            }
            
            let dbUser = DbUser(uid: "dddlslslslsls", fullName: user.displayName ?? "", coins: 0)

            do {
                try db.collection("users").document(user.uid).setData(from: dbUser)
            } catch let error {
                self.printer.printt("Error writing city to Firestore: \(error)")
            }
            
            if let userImage = userImage {
                uploadImg(userId: user.uid, img: userImage)
            }
            
  
        }
        
    }
    
    
    private func uploadImg(userId: String, img: UIImage) {
        
        guard let imageData = img.jpegData(compressionQuality: 0.8) else {
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
    
    
    
    
    
    
    
}
