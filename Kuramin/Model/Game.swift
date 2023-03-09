//
//  Game.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import Foundation
import SwiftUI

class Game : ObservableObject {
    var id: String = ""
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
            newPlayer.displayName = "player" + String(i)
            if i <= 6 {
                newPlayer.isNotDummy = true
            }
            players.append(newPlayer)
        }
        
        
    }
    
}


