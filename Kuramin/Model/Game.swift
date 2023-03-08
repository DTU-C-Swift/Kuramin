//
//  Game.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import Foundation
import SwiftUI

class Game : ObservableObject {
    var isLoggedIn = false
    @Published var players: [Player] = []
    @Published var me: Player = Player()
    var host: Player = Player()
    
    init() {
        me.isNotDummy = true
    }
    
    
    func addDummyPlayers() {
        
        for i in 1...6 {
            let newPlayer = Player()
            newPlayer.id = UUID().uuidString
            newPlayer.name = "player" + String(i)
            if i <= 3 {
                newPlayer.isNotDummy = true
            }
            players.append(newPlayer)
        }
        
        
    }
    
}


