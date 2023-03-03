//
//  KuraminApp.swift
//  Kuramin
//
//  Created by Numan Bashir on 16/02/2023.
//

import SwiftUI
import Firebase



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
}



@main
struct KuraminApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

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
