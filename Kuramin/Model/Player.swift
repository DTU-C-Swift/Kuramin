//
//  Player.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import Foundation
import SwiftUI

class Player : ObservableObject {
    
    var id = ""
    var fullName: String = ""
    @Published var displayName = "NotSet"
    @Published var image: UIImage = UIImage(imageLiteralResourceName: "person_100")
    @Published var isNotDummy: Bool = false
    @Published var coins: Int = 0

    var p = Printer(tag: "Player", displayPrints: true)
    
    
    
    
    func setStrImg(imgName: String) {
        self.image = UIImage(imageLiteralResourceName: imgName)
    }
    
    func update(_ dbUser: DbUser) {
        //self.id = dbUser.uid
        if self.coins != dbUser.coins {
            self.coins = dbUser.coins
        }
        
        let newName = dbUser.fullName.split(separator: " ")
        
        if self.displayName != newName[0] {
            self.displayName = String(newName[0])
            self.fullName = dbUser.fullName
            
        }


        
        

    }
}
