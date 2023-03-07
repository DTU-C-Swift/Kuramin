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



class Service {
    var db = Firestore.firestore()
    
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
    
    
    func getUser() -> User? {
        
        var user = Auth.auth().currentUser
        
        
        
        
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
          let email = user.email
          let photoURL = user.photoURL
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
          // ...
            
            return user
        }
        
        //var url = user.getPhotoUrl() + "?access_token=ee9527604aa7a096cac66b83bc214868"

        
        return nil
        
    }
    
    
    
}
