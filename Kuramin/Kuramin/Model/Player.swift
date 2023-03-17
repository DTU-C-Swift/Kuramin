//
//  Player.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import Foundation
import SwiftUI

class Player : ObservableObject, Identifiable{
    
    private(set) var id: String
    private(set) var fullName: String = Util().NOT_SET
    @Published private(set) var displayName = Util().NOT_SET
    @Published private(set) var image: UIImage = UIImage(imageLiteralResourceName: "person_100")
    @Published private(set) var isLeft: Bool = false
    @Published private(set) var coins: Int = 0
    @Published private(set) var cardsInHand = -1
    @Published private(set) var randomNumber = -1

    private(set) var leftAt = Util().NOT_SET
    let lock = NSLock()
    
    
    
    var p = Printer(tag: "Player", displayPrints: true)
    
        

    init(id: String) {
        self.id = id
    }
    
    init(id: String, fullName: String?, displayName: String?, image: UIImage?, isLeft: Bool?, coins: Int?, cardsInHand: Int?) {
        self.id = id
        
        if let fullName = fullName {
            self.fullName = fullName
        }
        
        if let displayName = displayName {
            self.displayName = displayName
        }
        
        if let image = image {
            self.image = image
        }
        
        if let isLeft = isLeft {
            self.isLeft = isLeft
        }
        if let coins = coins {
            self.coins = coins

        }
        
        if let cardsInHand = cardsInHand {
            self.cardsInHand = cardsInHand
        }
    }
    
    
    
    
    
    
    
    
    

    func updateInfo(dbPlayer p: DbPlayer) {
        
        lock.lock()
        if p.pid != id {
            assert(false)
            lock.unlock()
        }

        
        if fullName != p.pName  {
            
            self.fullName = p.pName
            lock.unlock()
            setDisplayName()
            lock.lock()
        }
        
    
        if cardsInHand != p.cardsInHand  {
            self.cardsInHand = p.cardsInHand
        }

        if randomNumber != p.randomNum {
            self.randomNumber = p.randomNum
        }
        
        
        lock.unlock()
        self.p.write("Player updated: \(self.displayName), \(self.id)")

    }
    
    
    
    
    
    
    
    
    
    

    
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
    
    
    
    
    func setDisplayName() {
        let newName = self.fullName.split(separator: " ")
        if displayName != newName[0] {
            self.displayName = String(newName[0])
            
        }
    }
    
    
    func isItSame(player p: Player) -> Bool {
        
        lock.lock()
        if p.id != id {return false}
        
        if p.fullName != fullName {return false}
        if p.isLeft != isLeft {return false}
        if p.leftAt != leftAt {return false}
        if p.coins != coins {return false}
        if p.image != image {return false}
        if p.cardsInHand != cardsInHand {return false}
        if p.randomNumber != randomNumber {return false}

        lock.unlock()
        return true
        
    }
    
    
    
    
    
    
    ///--------------------------------------------     All the setters    ---------------------------------------------------///
    
    
    func setIsLeft(val: Bool) {
        lock.lock()
        self.isLeft = val
        
        if val == false {
            self.leftAt = Util().NOT_SET
        }
        
        lock.unlock()
    }
    
    
    func setLeftAt(date: String) {
        lock.lock()
        self.leftAt = date
        lock.unlock()
    }
    
    
    
    
//    func setStrImg(imgName: String) {
//        self.image = UIImage(imageLiteralResourceName: imgName)
//    }
    
    
}

