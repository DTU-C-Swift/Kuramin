//
//  Controller.swift
//  Kuramin
//
//  Created by MD. Zahed on 01/03/2023.
//

import Foundation
import SwiftUI

class Controller : ObservableObject {
    var game: Game;
    
    init(game: Game?) {
        self.game = game ?? Game()
    }
}
