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
    
}
