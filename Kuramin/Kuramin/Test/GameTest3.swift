//
//  GameTest3.swift
//  Kuramin
//
//  Created by MD. Zahed on 25/03/2023.
//

import Foundation

class GameTest3 {
    
    let p = Printer(tag: "GameTest3", displayPrints: true)
    @Published var testPassed: Bool = false
    
    
    
    func run() {
        testPassed = true
    }
}
