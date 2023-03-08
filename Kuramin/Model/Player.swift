//
//  Player.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import Foundation
import SwiftUI

class Player : ObservableObject {
    
    var id = ""
    @Published var name = "NotSet"
    @Published var image: UIImage = UIImage(imageLiteralResourceName: "person_100")
    @Published var isNotDummy: Bool = false

    
    func setImg(imgName: String) {
        self.image = UIImage(imageLiteralResourceName: imgName)
    }
}
