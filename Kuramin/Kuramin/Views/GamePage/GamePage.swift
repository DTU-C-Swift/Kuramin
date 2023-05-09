//
//  GamePageView.swift
//  Kuramin
//
//  Created by Numan Bashir on 16/02/2023.
//

import SwiftUI


struct GamePage: View {
    //@State private var isAnimating = false
    //@EnvironmentObject var navState: NavState
    //@EnvironmentObject var controller: Controller
    //@State var earlier: String = ""
    //@State var later: String = ""
    //@State private var changedTopColumn = false
    //@StateObject var game = Game()



    @Environment(\.presentationMode) var pm: Binding<PresentationMode>
    let printer = Printer(tag: "GamePage", displayPrints: true)
    @ObservedObject var controller = DataHolder.controller
    @ObservedObject var game = DataHolder.controller.game
    @State private var showingQuitGameAlert = false

    
    
    
    var body: some View {
        
        ZStack {
            
            BackgroundView(controller: controller, game: game)
            
            PlayersView(game: game)
            
            
            
            //------------ Back button ------------//
            VStack {
                Spacer()
                HStack {
                    
                    Button(action: {
                        showingQuitGameAlert = true
                    }) {
                        
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                            .scaleEffect(1.4)
                            .padding(.leading, 20)
                        
                    }
                    .padding(.bottom, 10)
                    
                    .alert(isPresented: $showingQuitGameAlert) {
                        Alert(title: Text("Confirmation"), message: Text("Are you sure you want to quit?"), primaryButton: .destructive(Text("Yes")) {
                            
                            
                            controller.exitLobby()
                            pm.wrappedValue.dismiss()
                        }, secondaryButton: .cancel())
                    }
                    
                    
                    Spacer()
                }
            }
            
            
            
            
            
            VStack {

                
                HStack{
                    
                    Spacer()
                    
                    
                    if game.id == Util.NOT_SET || game.id == "" {
                        Button(action: {
                            controller.addDummyPlayerInLobby()

                        }) {
                            Text("Invite player")
                        }
                        .padding(.all)
                    }

                    
                }
                
                Spacer()
                
                ZStack {
                    
                    HStack {
                        
                        Spacer()
                        MyPlayerViewInGamePage(me: controller.game.me, game: game)
                            .padding(.bottom, 0)
                        Spacer()
                        
                    }
                    

                }

            }
            
            
            
        }

        .navigationBarBackButtonHidden(true)
        .persistentSystemOverlays(.hidden)

        
        
        
        
        
        

//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
//            // App is about to be closed
//            self.printer.write("app is closing")
//        }

        
    }
    
    
    
    
    
}



struct GamePageView_Previews: PreviewProvider {
    static var previews: some View {
        GamePage()
        
        
    }
}



