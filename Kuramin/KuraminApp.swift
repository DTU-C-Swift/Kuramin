//
//  KuraminApp.swift
//  Kuramin
//
//  Created by Numan Bashir on 16/02/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct KuraminApp: App {

    init() {
        
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                //.environmentObject(Controller(game: nil))
        }
    }
}
