//
//  Player.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import Foundation
import SwiftUI

class Player : ObservableObject, Identifiable{
    
    var id: String
    var fullName: String = ""
    @Published var displayName = "NotSet"
    @Published var image: UIImage = UIImage(imageLiteralResourceName: "person_100")
    @Published var isLeft: Bool = false
    @Published var coins: Int = 0
    let lock = NSLock()
    var p = Printer(tag: "Player", displayPrints: true)
    
    init(id: String) {
        self.id = id
    }
    
    

    
    
//    func setStrImg(imgName: String) {
//        self.image = UIImage(imageLiteralResourceName: imgName)
//    }
    
    
    
    func update(_ dbUser: DbUser) {

        if self.coins != dbUser.coins {
            self.coins = dbUser.coins
        }

        let newName = dbUser.fullName.split(separator: " ")

        if self.displayName != newName[0] {
            self.displayName = String(newName[0])
            self.fullName = dbUser.fullName

        }

        self.p.write("Player updated: \(self.displayName), \(self.id)")

    }
    
    
    
//    func update(player: Player) {
//        //self.id = dbUser.uid
//        if self.coins != player.coins {
//            self.coins = player.coins
//        }
//
//        let newName = player.fullName.split(separator: " ")
//
//        if self.displayName != newName[0] {
//            self.displayName = String(newName[0])
//            self.fullName = player.fullName
//
//        }
//
//    }
    
    
    func setDisplayName() {
        let newName = self.fullName.split(separator: " ")
        if self.displayName != newName[0] {
            self.displayName = String(newName[0])
            
        }
    }
    
    
    
    
    
}

