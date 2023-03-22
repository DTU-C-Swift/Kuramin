
//
//  KuraminApp.swift
//  Kuramin
//
//  Created by Numan Bashir on 16/02/2023.
//

import SwiftUI
import Firebase
import FBSDKCoreKit



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
}


@main
struct KuraminApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    
    init() {
        
        FirebaseApp.configure()

    }
    var body: some Scene {
        WindowGroup {
            ContentView()
            //TestVIew()
            
                
                //.environmentObject(DataHolder.controller)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}



func applicationDidEnterBackground(_ application: UIApplication) {
    print("Appdelicat")
 // Save here
}
