//
//  GoogleAuth.swift
//  Kuramin
//
//  Created by Numan Bashir on 05/03/2023.
//

import Foundation
import SwiftUI
import Firebase
import GoogleSignIn

class GoogleAuth: NSObject, ObservableObject {
    
    @Published var user: User?
    private var handle: AuthStateDidChangeListenerHandle?
    
    func signIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            print("Error signing out: %@", error)
        }
    }
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.scopes = ["email"]
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else { return }
            self.user = user
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

extension GoogleAuth: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("Google sign in error: \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else {
            print("Missing authentication object off of google user")
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            if let error = error {
                print("Firebase sign in error: \(error.localizedDescription)")
                return
            }
            self?.user = authResult?.user
        }
    }
    
}



