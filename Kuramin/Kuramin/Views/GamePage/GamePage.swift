//
//  GamePageView.swift
//  Kuramin
//
//  Created by Numan Bashir on 16/02/2023.
//

import SwiftUI


struct GamePage: View {
    @State private var isAnimating = false
    @Environment(\.presentationMode) var pm: Binding<PresentationMode>
    @EnvironmentObject var navState: NavState
    let printer = Printer(tag: "GamePage", displayPrints: true)
    @State private var changedTopColumn = false

    //@EnvironmentObject var controller: Controller
    @ObservedObject var controller = DataHolder.controller
    @ObservedObject var game = DataHolder.controller.game
    @State var earlier: String = ""
    @State var later: String = ""
    
    
    
    var body: some View {
        
        ZStack {
            
            BackgroundView()
            
            PlayersView(game: game)
            
            VStack {
                
                HStack{
                    
                    
                    Button(action: {
                        pm.wrappedValue.dismiss()
                        //game.removeNode(nodeToRemove: game.head!.nextPlayer!)
                        
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                            .scaleEffect(1.6)
                            .padding(.leading, 20)
                        
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    Button(action: {
                        
                        controller.goToLobby(addDummyPlayer: true)
                        
                    }) {
                        Text("Add")
                    }
                    
                    
                    
                }
                
                Spacer()
                
                ZStack {
                    
                    HStack {
                        
                        Spacer()
                        MyPlayerViewInGamePage(me: controller.game.me, game: game)
                            .padding(.bottom, 10)
                        Spacer()
                        
                    }
                    
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            
                            //controller.changeLobbyName()
                            controller.exitLobby()
                            
                        }) {
                            Text("Rename lobby")
                        }

                    }
                    
                    
                }
                
                
            }
            
            
            
        }

        .navigationBarBackButtonHidden(true)
//        .onChange(of: scenePhase) { newPhase in
//
//            self.printer.write("on change")
//
//
//            if newPhase == .background {
//                // App is about to be closed
//                self.printer.write("app is closing")
//
//            }
//            else {
//                self.printer.write("app is oppening")
//            }
//        }
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
//            // App is about to be closed
//            self.printer.write("app is closing")
//        }

        
        .persistentSystemOverlays(.hidden)
        .onAppear() {
            //controller.game.addDummyPlayers(val: 7)
        }

        
    }
    
    
    
    
    
}



struct GamePageView_Previews: PreviewProvider {
    static var previews: some View {
        GamePage()
        
        
    }
}



