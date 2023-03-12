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
    
    
    //@EnvironmentObject var controller: Controller
    @ObservedObject var controller = DataHolder.controller
    
    init() {
        controller.game.addDummyPlayers()
    }
    
    
    var body: some View {
        
        ZStack {
            
            BackgroundView()
            
            VStack {
                
                HStack() {
                    Spacer()
                    CirclePicView(player: controller.game.players[0])
                    Spacer()
                    CirclePicView(player: controller.game.players[3])
                    Spacer()
                    CirclePicView(player: controller.game.players[4])
                    Spacer()
                    
                }
                .padding(.top, 4)
                
                
                
                
                Spacer()
                HStack() {
                    
                    VStack{
                        
                        CirclePicView(player: controller.game.players[1])
                        
                        Spacer()
                        CirclePicView(player: controller.game.players[5])
                        
                    }
                    
                    
                    Spacer()
                    
                    VStack {
                        CirclePicView(player: controller.game.players[2])
                        Spacer()
                        CirclePicView(player: controller.game.players[6])
                        
                    }
                    
                }
                
                
                Spacer()
                ZStack() {
                    
                    
                    HStack {
                        
                        Spacer()
                        MyPlayerViewInGamePage(me: controller.game.me)
                            .padding(.bottom, 10)
                        Spacer()
                        
                    }
                    
                    
                    
                    HStack {
                        Button(action: {
                            pm.wrappedValue.dismiss()
                            
                        }) {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white)
                        }
                        
//                        Button(action: {
//
//
//                        }) {
//                            Image(systemName: "chevron.backward")
//                                .foregroundColor(.white)
//                        }
                        
                        Spacer()
                    }
                    
                    
                }
                
                
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                // App is about to be closed
                self.printer.printt("app is closing")
                
            }
            else {
                self.printer.printt("app is oppening")
            }
        }
        .persistentSystemOverlays(.hidden)
        .onAppear() {
            controller.service.goToLobby(player: controller.game.me)

        }
        
    }
    
    
    
    
    
}



struct GamePageView_Previews: PreviewProvider {
    static var previews: some View {
        GamePage()
        
        
    }
}



