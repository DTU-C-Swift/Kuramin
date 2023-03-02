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
    
    
    func matchMaker(player: Player) {
        var ref = db.collection("matchMaker")
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
    
}
