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
    var controller: Controller
    
    init() {
        self.controller = DataHolder.controller
        controller.game.addDummyPlayers()
        
        
    }
    
    
    var body: some View {
        
        ZStack {
            
            
            BackgroundView()
            
            VStack {
                
                HStack() {
                    
                    
                    
                    if controller.game.players[0].isNotDummy{
                        Spacer()
                        CirclePicView(player: controller.game.players[0])
                    }
                    
                    if controller.game.players[3].isNotDummy {
                        Spacer()
                        CirclePicView(player: controller.game.players[3])
                    }

                    if controller.game.players[4].isNotDummy {
                        Spacer()
                        CirclePicView(player: controller.game.players[4])
                    }

                    
//                    if controller.game.players[5].isNotDummy{
//                        Spacer()
//                        CirclePicView(player: controller.game.players[5])
//                    }
                    
                    Spacer()
                    
                }
                .padding(.top, 4)
                
               
                
                
                Spacer()
                HStack() {
                    
                    VStack{
                        
                        if controller.game.players[1].isNotDummy {
                            CirclePicView(player: controller.game.players[1])
                        }
                        
                        if controller.game.players[5].isNotDummy {
                            Spacer()
                            CirclePicView(player: controller.game.players[5])
                        }
                    }
                    
                    
                    Spacer()
                    
                    VStack {
                        if controller.game.players[2].isNotDummy {
                            CirclePicView(player: controller.game.players[2])
                        }
                        
                        if controller.game.players[6].isNotDummy {
                            Spacer()
                            CirclePicView(player: controller.game.players[6])
                        }
                        
                    }

                    

                    
                    
                }
                
                
                Spacer()
                ZStack() {
                    
                    
                    HStack {
                        
                        Spacer()
                        ZStack {
                            Rectangle()
                                .fill(Color.cyan)
                                .frame(width: 300, height: 40)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 0.5)
                                )
                            
                                .shadow(radius: 20)
                            
                            if controller.game.me.isNotDummy {
                                CirclePicView(player: controller.game.me)
                            }
                            

                            
                        }
                        Spacer()
                        
                    }
                    
                    
                    
                    HStack {
                        Button(action: {
                            pm.wrappedValue.dismiss()
                            
                        }) {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            
                            controller.service.goToLobby(player: controller.game.me)
                            if user != nil {
                                
                            }
                            


                        }) {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white)
                        }
                        
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

        
        
    }
   

    
    
    
}



struct GamePageView_Previews: PreviewProvider {
    static var previews: some View {
        GamePage()
        
        
    }
}



