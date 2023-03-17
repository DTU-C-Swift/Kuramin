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
    @Published private(set) var image: UIImage = Util().defaultProfileImg
    @Published private(set) var isLeft: Bool = false
    @Published private(set) var coins: Int = 0
    @Published private(set) var cardsInHand = -1
    @Published private(set) var randomNumber = -1

    private(set) var leftAt = Util().NOT_SET
    private let lock = NSLock()
    
    
    
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
    
    
    
    
    
    
    
    
// This method is for everyone(other players) except "me"

    func updateInfo(dbPlayer p: DbPlayer) {
        
        lock.lock()
        if p.pid != id {
            assert(false)
            //lock.unlock()
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
    
    
    
    

// This method should only be called if it "me".
    
    func updateMe(dbUser: DbUser) {

        lock.lock()
        
        if self.coins != dbUser.coins {
            self.coins = dbUser.coins
        }

        let newName = dbUser.fullName.split(separator: " ")
        let newDisPlayName = String(newName[0])
        
        if displayName != newDisPlayName {
            self.displayName = newDisPlayName
            self.fullName = dbUser.fullName

        }

        self.p.write("Updated me: \(self.displayName), \(self.id)")
        
        lock.unlock()

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
    
    
    func setId(pid newPid: String) {
        lock.lock()
        if id == newPid || newPid.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            lock.unlock()
            return
        }
        self.id = newPid
        lock.unlock()
    }
    
    
    
    func setFullName(fullName newName: String) {
        lock.lock()
        if fullName == newName {
            lock.lock()
            return
        }
        self.fullName = newName
        lock.unlock()
        setDisplayName()
        
    }
    
    
    func setDisplayName() {
        lock.lock()
        let newName = self.fullName.split(separator: " ")
        let newDisplayName = String(newName[0])
        
        if displayName != newDisplayName {
            self.displayName = newDisplayName
            
        }
        lock.unlock()
    }
    
    
    
    
    func setStrImg(img newImg: UIImage) {
        
        //let newImg = UIImage(imageLiteralResourceName: imgName)

        
        lock.lock()

        if let oldImgData = image.pngData(), let newImgData = newImg.pngData() {
            
            if oldImgData != newImgData {
                self.image = newImg
            }
        }
        
        
        lock.unlock()
    }
    
    
    
    
    func setIsLeft(isLeft newIsLeft: Bool) {
        lock.lock()
        self.isLeft = newIsLeft
        
        if newIsLeft == false {
            self.leftAt = Util().NOT_SET
            
        } else {
            self.leftAt = MyDate().getTime()
        }
        
        lock.unlock()
    }
    
    
    func setLeftAt(date newDate: String) {
        lock.lock()
        self.leftAt = newDate
        lock.unlock()
    }
    
    

    func setCoins(coins newCoins: Int) {
        
        lock.lock()
        if coins != newCoins {
            self.coins = newCoins
        }
        
        lock.unlock()
    }
    
    func setCardsInHand(cardInHad newCardInHand: Int) {
        
        lock.lock()
        
        if cardsInHand != newCardInHand {
            self.cardsInHand = newCardInHand
        }
        
        lock.unlock()
        
    }
    
    
    func setRandomNum(randNum newRandNum: Int) {
        
        lock.lock()
        
        if randomNumber != newRandNum {
            self.randomNumber = newRandNum
        }
        
        lock.unlock()
        
    }

    
    
}

