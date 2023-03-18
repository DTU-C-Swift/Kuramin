//
//  DbPlayer.swift
//  Kuramin
//
//  Created by MD. Zahed on 16/03/2023.
//

import Foundation
import FirebaseFirestoreSwift


public struct DbPlayerNullable: Codable {
    var pName: String?
    var pid: String?
    var randomNum: Int?
    var cardsInHand: Int?
    
    
    
    func mapToDbPlayer() -> DbPlayer? {
        
        
        
        if let pName = self.pName, let pid = self.pid, let randomNum = self.randomNum, let cardsInHand = self.cardsInHand {
            
            if pid.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                return nil
            }
            
    
            return DbPlayer(pName: pName, pid: pid, randomNum: randomNum, cardsInHand: cardsInHand)
            
        }
        
        print("DbPlayerNullable: player \(self.pid!) is nil")
        return nil
    }
    
    
    func toDictionary() -> [String: Any] {
        return [
            "pName": pName ?? Util().NOT_SET,
            "pid": pid ?? Util().NOT_SET,
            "randomNum": randomNum ?? -1,
            "cardsInHand": cardsInHand ?? -1
        ]
    }
    
}




public struct DbPlayer {
    var pName: String
    var pid: String
    var randomNum: Int
    var cardsInHand: Int
    

    
    
    func createPlayer() -> Player {
        
        return Player(id: pid, fullName: pName, image: nil, isLeft: false,
                      coins: nil, cardsInHand: cardsInHand, randomNum: randomNum)
    }
}

