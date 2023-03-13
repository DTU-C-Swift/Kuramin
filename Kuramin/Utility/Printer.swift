//
//  Printer.swift
//  Kuramin
//
//  Created by MD. Zahed on 09/03/2023.
//

import Foundation
import SwiftUI


class Printer {
    var tag: String
    var displayPrints: Bool
    
    init(tag: String, displayPrints: Bool) {
        self.tag = tag
        self.displayPrints = displayPrints
    }
    
    func printt(_ str: Any) {
        print(tag,": ", str)

    }
}

struct Util {
    let PROGRESSING = "display"
    let SUCCEDED = "succeded"
    let FAILED = "failed"
}
