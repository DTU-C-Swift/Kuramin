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
                    
                    if game.fiveFromRight?.id != defaulId {
                        CirclePicView(player: game.fiveFromRight!, game: game)

                    }
                }

                
                
                
                if game.fourFromRight != nil {
                                        
                    if game.fourFromRight?.id != defaulId {
                        Spacer()
                        CirclePicView(player: game.fourFromRight!, game: game)
                    }

                }


                if game.threeFromRight != nil {
                    
                    if game.threeFromRight?.id != defaulId {
                        Spacer()
                        CirclePicView(player: game.threeFromRight!, game: game)
                    }
                }

                Spacer()


            }
            .padding(.top, 4)


            Spacer()
            HStack() {

                VStack{

                    Spacer()

                    if game.sixFromRight != nil {
                        if game.sixFromRight?.id != defaulId {
                            CirclePicView(player: game.sixFromRight!, game: game)
                            Spacer()
                        }

                    }

                    if game.sevenFromRight != nil {
                        if game.sevenFromRight?.id != nil {
                            CirclePicView(player: game.sevenFromRight!, game: game)
                        }
                        
                    }

                    Spacer()

                }


                Spacer()
                VStack {
                    Spacer()
                    if game.twoFromRight != nil {
                        
                        if game.twoFromRight?.id != defaulId {
                            CirclePicView(player: game.twoFromRight!, game: game)
                            Spacer()
                        }
                        

                    }

                    if game.oneFromRight != nil {
                        
                        if game.oneFromRight?.id != defaulId {
                            CirclePicView(player: game.oneFromRight!, game: game)

                        }
                    }

                    Spacer()
                }

            }


            Spacer()


        }
        
        
    }
}

struct PlayersView_Previews: PreviewProvider {
    //@ObservedObject var game = DataHolder.controller.game
    
    static var previews: some View {
        PlayersView(game: DataHolder.controller.game)
    }
}
