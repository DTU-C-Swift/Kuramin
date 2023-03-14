//
//  GamePageView.swift
//  Kuramin
//
//  Created by Numan Bashir on 16/02/2023.
//

import SwiftUI
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


struct GamePage: View {
    @State private var isAnimating = false
    @Environment(\.presentationMode) var pm: Binding<PresentationMode>
    @EnvironmentObject var navState: NavState
    @State var user: User? = nil
    @Environment(\.scenePhase) private var scenePhase
    let printer = Printer(tag: "GamePage", displayPrints: true)
    @State private var changedTopColumn = false
    //@State private var changedTopColumn = false

    
    
    
    //@EnvironmentObject var controller: Controller
    @ObservedObject var controller = DataHolder.controller
    @ObservedObject var game = DataHolder.controller.game
    
    
    init() {
    }
    
    
    var body: some View {
        
        ZStack {
            
            BackgroundView()
            
            VStack {
                
                ZStack {
                    
                    
                    HStack{
                        
                        Button(action: {
                            pm.wrappedValue.dismiss()
                            
                        }) {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white)
                                .scaleEffect(1.8)
                                .padding(.bottom, 20)
                                .padding(.leading, 20)

                        }
                        
                        
                        
//                        Button(action: {
//                            if controller.test.isLoggedIn == true {
//                                controller.test.isLoggedIn = false
//
//                            }
//                            else {
//                                controller.test.isLoggedIn = true
//
//                            }
//                        }) {
//                            Image(systemName: "chevron.backward")
//                                .foregroundColor(.white)
//                                .scaleEffect(1.8)
//                                .padding(.bottom, 20)
//                                .padding(.leading, 20)
//
//                        }
                        
                        
                        
                        Spacer()
                        
                    }
                    
                    
                   
                    HStack() {
                        Spacer()
                        if game.players.count > 0 {
                            CirclePicView(player: controller.game.players[0])
                        
                        }
                        
                        if game.players.count > 3 {
                            Spacer()
                            CirclePicView(player: controller.game.players[3])
                            
                        }
                        
                        
                        if game.players.count > 4 {
                            Spacer()
                            CirclePicView(player: controller.game.players[4])
                            
                        }
                        
                        Spacer()
                        
                        
//                        List(controller.game.players) { item in
//
//                            CirclePicView(player: item)
//                            Spacer()
//                        }
                        
//                        Spacer()
//                        CirclePicView(player: controller.game.players[0])
//                        Spacer()
//                        CirclePicView(player: controller.game.players[3])
//                        Spacer()
//                        CirclePicView(player: controller.game.players[4])
//                        Spacer()

                    }
                    .padding(.top, 4)
                    
                }
                

                
                
                
                
                Spacer()
                HStack() {
                    
                    VStack{
                        
                        Spacer()
                        
                        if game.players.count > 5 {
                            CirclePicView(player: controller.game.players[5])
                            Spacer()
                        }
                        
                        
                        
                        if game.players.count > 1 {
                            CirclePicView(player: controller.game.players[1])
                        }
                        
                        Spacer()

                    }
                    
                    
                    Spacer()
                    VStack {
                        
                        if game.players.count > 2 {
                            CirclePicView(player: controller.game.players[2])

                        }
                        
                        
                        if game.players.count > 6 {
                            CirclePicView(player: controller.game.players[6])
                        }
                        

                    }
                    
                }
                
                
                Spacer()
                    
                HStack {
                    
                    Spacer()
                    MyPlayerViewInGamePage(me: controller.game.me)
                        .padding(.bottom, 10)
                    Spacer()
                    
                }
            }
            
    
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                // App is about to be closed
                self.printer.write("app is closing")
                
            }
            else {
                self.printer.write("app is oppening")
            }
        }
        .persistentSystemOverlays(.hidden)
        .onAppear() {
            controller.service.goToLobby()

        }
//        .onChange(of: controller.game.players) { newValue in
//            if
//        }
        .onChange(of: controller.test.isLoggedIn) { newValue in
            self.printer.write("Player list changed: \(newValue)")
        }
    }
    
    
    
    
    
}



struct GamePageView_Previews: PreviewProvider {
    static var previews: some View {
        GamePage()
        
        
    }
}



