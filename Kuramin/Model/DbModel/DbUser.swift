//
//  DbUser.swift
//  Kuramin
//
//  Created by MD. Zahed on 08/03/2023.
//

import Foundation
import FirebaseFirestoreSwift


struct DbUser: Codable {
    @DocumentID var uid: String?
    var fullName: String
    var coins: Int
    
    func toString() -> String {
        return "UserId: \(uid ?? "nil"), fullName: \(fullName), coins: \(coins)"

    }
}


struct Lobby: Codable {
    var host: String
    var playerIds: [String]

}
