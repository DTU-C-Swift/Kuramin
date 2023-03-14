//
//  Printer.swift
//  Kuramin
//
//  Created by MD. Zahed on 14/03/2023.
//

import Foundation


class Printer {
    var tag: String
    var displayPrints: Bool
    
    init(tag: String, displayPrints: Bool) {
        self.tag = tag
        self.displayPrints = displayPrints
    }
    
    func write(_ str: Any) {
        print(tag,": ", str)

    }
    
    func writeRed(_ str: Any) {
        //print(tag,": ", str, modifier: .red )
        //print("\(tag): \("\u{001B}[31m\(str)\u{001B}[0m")")
        self.write(str)


    }
    
    
}
