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
    @Environment(\.scenePhase) private var scenePhase
    let printer = Printer(tag: "GamePage", displayPrints: true)
    @State private var changedTopColumn = false
    
    //@EnvironmentObject var controller: Controller
    @ObservedObject var controller = DataHolder.controller
    @ObservedObject var game = DataHolder.controller.game
    @State var earlier: String = ""
    @State var later: String = ""
    
    
    init() {
        // controller.game.addDummyPlayers()
    }
    
    
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
                            .padding(.bottom, 0)
                            .padding(.top, 5)
                            .padding(.leading, 20)
                        
                    }
                    
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
                            
                            controller.changeLobbyName()
                            
                        }) {
                            Text("Rename lobby")
                        }

                    }
                    
                    
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
            //controller.service.goToLobby(addDummyPlayer: false)
            
            //            earlier = MyDate().getTime()
            //
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //                later = MyDate().getTime()
            //            }
            
            controller.game.addDummyPlayers(val: 7)
            //controller.service.goToLobby(val: false)
            //controller.goToLobby(addDummyPlayer: false)
            
            
        }
        
    }
    
    
    
    
    
}



struct GamePageView_Previews: PreviewProvider {
    static var previews: some View {
        GamePage()
        
        
    }
}



