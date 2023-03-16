//
//  DbPlayer.swift
//  Kuramin
//
//  Created by MD. Zahed on 16/03/2023.
//

import Foundation
import FirebaseFirestoreSwift



public struct DbLobby: Codable {
    var gameId: String?
    var host: String?
    var whosTurn: String?
    var players: [DbPlayer]?
}


public struct DbPlayer: Codable {
    var pid: String?
    var randomNum: Int?
    var cardsInHand: Int?
    
}


