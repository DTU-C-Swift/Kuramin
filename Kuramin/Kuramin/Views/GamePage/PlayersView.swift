//
//  PlayersView.swift
//  Kuramin
//
//  Created by MD. Zahed on 17/03/2023.
//

import SwiftUI


struct PlayersView: View {
    //@Binding var game: Game
    
    @ObservedObject var game: Game
    
    let defaulId = Util().NOT_SET
    
    init(game: Game) {
        self.game = game
    }
    

    
    
    var body: some View {


        ZStack(alignment: .top) {

            VStack {
                HStack() {
                    Spacer()
                    
                    if game.fiveFromRight != nil {
                        CirclePicView(player: game.fiveFromRight!, game: game)
                    }

                    
                    if game.fourFromRight != nil {
                                            
                        Spacer()
                        CirclePicView(player: game.fourFromRight!, game: game)

                    }


                    if game.threeFromRight != nil {
                        Spacer()
                        CirclePicView(player: game.threeFromRight!, game: game)
                    }

                    Spacer()


                }
                .padding(.top, 4)

            }

            
            
            
            VStack {
                Spacer()
                HStack() {

                    
                    // ------------ Left Side -------------- //
                    VStack{

                        Spacer()

                        if game.sixFromRight != nil {
                            CirclePicView(player: game.sixFromRight!, game: game)
                        }

                        if game.sevenFromRight != nil {
                            Spacer()
                            CirclePicView(player: game.sevenFromRight!, game: game)
                        }

                        Spacer()

                    }


                    Spacer()
                    
                    
                    // ------------ Right Side -------------- //

                    VStack {
                        Spacer()
                        if game.twoFromRight != nil {
                            CirclePicView(player: game.twoFromRight!, game: game)
                        }

                        if game.oneFromRight != nil {
                            Spacer()
                            CirclePicView(player: game.oneFromRight!, game: game)
                        }

                        Spacer()
                    }

                }
                
                Spacer()
            }
            



        }
        .padding(.horizontal, 3)
        
        
    }
}

struct PlayersView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayersView(game: DataHolder.controller.game)
    }
}
