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
    @Published var game: Game = Game()
    var service: Service = Service()
    @Published var isLoggedIn: Bool = false
    @Published var bufferState: String = ""
    @Published var image: UIImage? = nil
    
    init() {
        self.listenForLogout()
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
