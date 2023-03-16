//
//  DbUser.swift
//  Kuramin
//
//  Created by MD. Zahed on 08/03/2023.
//

import Foundation
import FirebaseFirestoreSwift


public struct DbUser: Codable {
    @DocumentID var uid: String?
    var fullName: String
    var coins: Int
    
    func toString() -> String {
        return "UserId: \(uid ?? "nil"), fullName: \(fullName), coins: \(coins)"

    }
}


public struct FirstLobby: Codable {
    var host: String
    var playerIds: [String]


    mutating func removeDuplicates() {
        var newIds = Array(Set(self.playerIds))
        self.playerIds = newIds
        print("DBuser:\(self.playerIds)")
    }

}
