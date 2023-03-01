//
//  Game.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import Foundation
import SwiftUI

class Game : ObservableObject {
    var controller: Controller
    var isLoggedIn = false
    @Published var players = [Player]()
    init(controller: Controller?) {
        self.controller = controller ?? Controller()
    }

}
