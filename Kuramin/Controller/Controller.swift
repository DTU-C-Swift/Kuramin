//
//  Controller.swift
//  Kuramin
//
//  Created by MD. Zahed on 01/03/2023.
//

import Foundation
import SwiftUI
import Firebase

class Controller : ObservableObject {
    @Published var game: Game;
    var service = Service()
    @Published var isLoggedIn: Bool = false
    @Published var loginBtnClicked: Bool = false
    
    init(game: Game?) {
        self.game = game ?? Game()
        //self.listenForLogout()
    }
    
    
    
    
    func listenForLogout() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.isLoggedIn = false
                print("login false")

            }
            else {
                print("login true")
                self.isLoggedIn = true
            }
            
        }
    }

}
