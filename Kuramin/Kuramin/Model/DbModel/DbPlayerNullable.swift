//
//  DbPlayer.swift
//  Kuramin
//
//  Created by MD. Zahed on 16/03/2023.
//

import Foundation
import FirebaseFirestoreSwift


public struct DbPlayerNullable: Codable {
    var pid: String?
    var randomNum: Int?
    var cardsInHand: Int?
    
    
    
    func mapToDbPlayer() -> DbPlayer? {
        
        if let pid = self.pid, let randomNum = self.randomNum, let cardsInHand = self.cardsInHand {
            return DbPlayer(pid: pid, randomNum: randomNum, cardsInHand: cardsInHand)
            
        } else {
            
            print("DbPlayerNullable: player \(self.pid!) is nil")
        }
        
        
        return nil
    }
    
}


public struct DbPlayer {
    var pid: String
    var randomNum: Int
    var cardsInHand: Int
    

}

