//
//  Card.swift
//  Kuramin
//
//  Created by MD. Zahed on 12/03/2023.
//

import Foundation


struct Card {
    var suit: Suit
    var value: Int
    
    init(suit: Suit, value: Int) {
        self.suit = suit
        self.value = value
    }
}




enum Suit: String, CaseIterable {
    case heart
    case dimond
    case club
    case spade
}
