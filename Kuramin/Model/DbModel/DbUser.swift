//
//  DbUser.swift
//  Kuramin
//
//  Created by MD. Zahed on 08/03/2023.
//

import Foundation
import FirebaseFirestoreSwift


//class DbUser {
//    var uid: String = ""
//    var fullName: String = ""
//}

struct DbUser: Codable {
    @DocumentID var uid: String?
    var fullName: String
    var coins: Int
}
