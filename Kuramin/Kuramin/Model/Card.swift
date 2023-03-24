//
//  Card.swift
//  Kuramin
//
//  Created by MD. Zahed on 12/03/2023.
//

import Foundation


struct Card {
    var suit: Character
    var value: Int
    
    init(suit: Character, value: Int) {
        self.suit = suit
        self.value = value
    }
}




enum Suit: String {
    case H = "H"
    case D = "D"
    case C = "C"
    case S = "S"
}

enum Value: Int {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case eleven = 11
    case twelve = 12
    case thirteen = 13
}

