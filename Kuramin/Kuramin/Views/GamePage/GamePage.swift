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
                        
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                            .scaleEffect(1.6)
                            .padding(.bottom, 0)
                            .padding(.top, 5)
                            .padding(.leading, 20)
                        
                    }
                    
                    Button(action: {
                        //controller.game.isGameStarted = true
                        controller.service.goToLobby(val: true)
                        //controller.game.setPlayerPosition()
                        //controller.game.setPlayerPositions2()
                        
                        //controller.service.goToLobby(val: )
                        
                        if MyDate().isEarlier(earlierTime: later, laterTime: earlier) {
                            self.printer.write("Earlier")
                        }
                        
                        else {
                            self.printer.write("Later")
                        }
                        
                        
                    }) {
                        Text("Add player")
                        
                    }
                    
                    
                    Spacer()
                    
                }

                Spacer()
                
                HStack {
                    
                    Spacer()
                    MyPlayerViewInGamePage(me: controller.game.me, game: game)
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
            //controller.service.goToLobby()
            
            //            earlier = MyDate().getTime()
            //
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //                later = MyDate().getTime()
            //            }
            
            //controller.game.addDummyPlayers()
            controller.service.goToLobby(val: false)
            
        }
        
    }
    
    
    
    
    
}



struct GamePageView_Previews: PreviewProvider {
    static var previews: some View {
        GamePage()
        
        
    }
}



