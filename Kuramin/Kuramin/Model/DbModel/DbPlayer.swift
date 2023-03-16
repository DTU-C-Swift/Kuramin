//
//  DbPlayer.swift
//  Kuramin
//
//  Created by MD. Zahed on 16/03/2023.
//

import Foundation
import FirebaseFirestoreSwift


public struct DbPlayer: Codable {
    @DocumentID var pid: String?
    var cards: [DbCard]
    var nextPid: String
    var prevPid: String
    
}


