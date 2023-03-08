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


class Service {
    var db = Firestore.firestore()
    let storage = Storage.storage()
    
    func fetchData(){
        db.collection("matches").getDocuments { snapshot, err in
            
            if err == nil {
                
                for it in snapshot!.documents {
                    print("\(it.documentID) => \(it.data())")
                }
                
                
                
            }
            else {
                
                print("Error getting documents: \(err)")
                
            }
            
        }
        
    }
    
    
    func intializeGame(p: Player) {
        
        db.collection("lobby").getDocuments { snapshot, err in
            if snapshot != nil {
                if snapshot?.count == 0 {
                    self.matchMaker(player: p)
                }
                else {
                    print("Lobby is not empty")
                }
            }
            
            
        }
        
    }
    
    
    
    
    
    
    func matchMaker(player: Player) {
        var ref = db.collection("lobby")
        //ref.document(player.id).setData(["id" : player.id])
        
        ref.document(player.id).setData([:
                                        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    
    
    
    
    
    
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
    
    
    //    func getUser() -> User? {
    //    }
    
    
    func createUser(userImage: UIImage?) {
        if userImage == nil {return}
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            _ = user.uid
            _ = user.email
            _ = user.photoURL
            var multiFactorString = "MultiFactor: "
            for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
            }
            
            //let arr = user.displayName?.split(separator: " ")
            
    
            var dictionary: [String: Any] = [:]
            dictionary["uid"] = user.uid
            dictionary["email"] = user.email
            //dictionary["firs_name"] = arr?[0]
            dictionary["fullName"] = user.displayName
            
            
            do {
                try db.collection("users").document(user.uid).setData(dictionary)
            } catch let error {
                print("Error writing city to Firestore: \(error)")
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

        let imagesRef = storage.reference().child("images").child(userId)
        let filename = "\(userId).jpg"
        let imageRef = imagesRef.child(filename)

        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let uploadTask = imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            print("Image uploaded successfully!")
        }
        
    }
    
    
    
    
}
