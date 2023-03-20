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


            Spacer()
            HStack() {

                VStack{

                    Spacer()

                    if game.sixFromRight != nil {
                        CirclePicView(player: game.sixFromRight!, game: game)
                        Spacer()
                    }

                    if game.sevenFromRight != nil {

                        CirclePicView(player: game.sevenFromRight!, game: game)
                    }

                    Spacer()

                }


                Spacer()
                VStack {
                    Spacer()
                    if game.twoFromRight != nil {
                        
                        CirclePicView(player: game.twoFromRight!, game: game)
                            .frame(width: 60, height: 80)

                        Spacer()
                    }

                    if game.oneFromRight != nil {
                        CirclePicView(player: game.oneFromRight!, game: game)
                        
                    }

                    Spacer()
                }

            }


            Spacer()


        }
        .padding(.horizontal, 5)
        
        
    }
}

struct PlayersView_Previews: PreviewProvider {
    //@ObservedObject var game = DataHolder.controller.game
    
    static var previews: some View {
        PlayersView(game: DataHolder.controller.game)
    }
}
