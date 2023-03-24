//
//  Player.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import Foundation
import SwiftUI

class Player : ObservableObject {
    
    private(set) var id: String
    @Published private(set) var fullName: String = Util.NOT_SET
    @Published private(set) var displayName = Util.NOT_SET
    @Published private(set) var image: UIImage = Util.defaultProfileImg
    @Published private(set) var isLeft: Bool = false
    @Published private(set) var coins: Int = Util.NOTSET_INT
    @Published private(set) var cardsInHand = Util.NOTSET_INT
    @Published private(set) var randomNumber = Util.NOTSET_INT
    private(set) var isDefaultImg = true
    private(set) var cards: [Card] = []

    private(set) var leftAt = Util.NOT_SET
    private let playerLock = DispatchSemaphore(value: 1)
    
    var nextPlayer: Player?
    var prevPlayer: Player?
    
    
    var p = Printer(tag: "Player", displayPrints: true)
    
        

    init(id: String) {
        self.id = id
    }
    
    init(id: String, fullName: String?, image: UIImage?, isLeft: Bool?, coins: Int?, cardsInHand: Int?, randomNum: Int?) {
        self.id = id
        
        if let fullName = fullName {
            self.fullName = fullName
            setDisplayName()
            
        }
        
        
        if let image = image {
            self.image = image
            self.isDefaultImg = false
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
        
        if let randomNum = randomNum {
            self.randomNumber = randomNum
        }
    }
    
    
    
    func lock() {
        playerLock.wait()
    }
    
    func unlock() {
        playerLock.signal()
    }
    
    func updateInfo(player p: Player) {
        
        var anyChanges = false
        lock()
        if p.id != id {
            //assert(false)
            unlock()
            assert(false)
        }

        
        if fullName != p.fullName  {
            
            self.fullName = p.fullName
            unlock()
            setDisplayName()
            lock()
            anyChanges = true
        }
        
    
        if cardsInHand != p.cardsInHand  {
            self.cardsInHand = p.cardsInHand
            anyChanges = true

        }

        if randomNumber != p.randomNumber {
            self.randomNumber = p.randomNumber
            anyChanges = true

        }
        
        // TODO set image
        
        if isDefaultImg && !p.isDefaultImg {
            self.image = p.image
            anyChanges = true
        }
        
        
        unlock()
        
        if anyChanges {
            self.p.write("Player updated: \(self.displayName), \(self.id)")
        }

    }

    
    
    
    
    
    
    
// This method is for everyone(other players) except "me"

    func updateInfo(dbPlayer p: DbPlayer) {
        
        lock()
        if p.pid != id {
            //assert(false)
            unlock()
            assert(false)
        }

        
        if fullName != p.pName  {
            
            self.fullName = p.pName
            unlock()
            setDisplayName()
            lock()
        }
        
    
        if cardsInHand != p.cardsInHand  {
            self.cardsInHand = p.cardsInHand
        }

        if randomNumber != p.randomNum {
            self.randomNumber = p.randomNum
        }
        
        
        self.cards = p.mapToCards()
        
        
        
        unlock()
        self.p.write("Player updated: \(self.displayName), \(self.id)")

    }
    
    
    
    

/// This method should only be called if it "me".
    
    func updateMe(dbUser: DbUser) {

        lock()
        
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
        
        unlock()

    }
    
    
    
    

    
    
    func isItSame(player p: Player) -> Bool {
        
        lock()
        if p.id != id {return false}
        
        if p.fullName != fullName {return false}
        if p.isLeft != isLeft {return false}
        if p.leftAt != leftAt {return false}
        if p.coins != coins {return false}
        if p.image != image {return false}
        if p.cardsInHand != cardsInHand {return false}
        if p.randomNumber != randomNumber {return false}

        unlock()
        return true
        
    }
    
    
    
    
    
    
    ///--------------------------------------------     All the setters    ---------------------------------------------------///
    
    
    func setId(pid newPid: String) {
        lock()
        if id == newPid || newPid.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            unlock()
            return
        }
        self.id = newPid
        unlock()
    }
    
    
    
    func setFullName(fullName newName: String) {
        lock()
        if fullName == newName {
            lock()
            return
        }
        self.fullName = newName
        unlock()
        setDisplayName()
        
    }
    
    
    private func setDisplayName() {
        lock()
        let newName = self.fullName.split(separator: " ")
        let newDisplayName = String(newName[0])
        
        if displayName != newDisplayName {
            self.displayName = newDisplayName
            
        }
        unlock()
    }
    
    
    
    
    func setStrImg(img newImg: UIImage) {
        
        //let newImg = UIImage(imageLiteralResourceName: imgName)

        
        lock()

        if let oldImgData = image.pngData(), let newImgData = newImg.pngData() {
            
            if oldImgData != newImgData {
                self.image = newImg
                self.isDefaultImg = false
            }
        }
        
        
        unlock()
    }
    
    
    
    
    func setIsLeft(isLeft newIsLeft: Bool) {
        lock()
        self.isLeft = newIsLeft
        
        if newIsLeft == false {
            self.leftAt = Util.NOT_SET
            
        } else {
            self.leftAt = MyDate().getTime()
        }
        
        unlock()
    }
    
    
    func setLeftAt(date newDate: String) {
        lock()
        self.leftAt = newDate
        unlock()
    }
    
    

    func setCoins(coins newCoins: Int) {
        
        lock()
        if coins != newCoins {
            self.coins = newCoins
        }
        
        unlock()
    }
    
    
    
    func setCardsInHand(cardInHad newCardInHand: Int) {
        
        lock()
        
        if cardsInHand != newCardInHand {
            self.cardsInHand = newCardInHand
        }
        
        unlock()
        
    }
    
    
    
//    func setRandomNum(randNum newRandNum: Int) {
//        DispatchQueue.main.async {
//            if self.randomNumber != newRandNum {
//                self.randomNumber = newRandNum
//            }
//        }
//    }

    
    
    func setRandomNum(randNum newRandNum: Int) {

        lock()

        if randomNumber != newRandNum {
            self.randomNumber = newRandNum
        }

        unlock()

    }

    
    func addCard(card: Card) {
        self.cards.append(card)
    }
    
    
}

