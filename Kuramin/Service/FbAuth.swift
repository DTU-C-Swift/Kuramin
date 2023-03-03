//
//  FbAuth.swift
//  Kuramin
//
//  Created by MD. Zahed on 03/03/2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

import FacebookCore
import FacebookLogin

class FbAuth {
    
    
    
    
    func login(credential: AuthCredential, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(with: credential, completion: { (firebaseUser, error) in
            print(firebaseUser)
            completionBlock(error == nil)
        })
    }
    
    
    
}
