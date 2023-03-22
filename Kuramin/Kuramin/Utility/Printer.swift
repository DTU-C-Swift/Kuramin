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
        print("MyTag=>\(tag): \(str)")

    }
    
    
//
//    func error(_ str: Any) {
//        print("📕 \(str)")
//    }
//
//
//
//    func success(_ str: Any) {
//        self.write("\n📗 \(str)")
//    }
//
//
//    func warning(_ str: Any) {
//        self.write("\n📙 \(str)")
//    }
//
//
//    func action(_ str: Any) {
//        self.write("\n📘 \(str)")
//    }
//
//
//    func cancelled(_ str: Any) {
//        self.write("\n📓 \(str)")
//    }
    
}
