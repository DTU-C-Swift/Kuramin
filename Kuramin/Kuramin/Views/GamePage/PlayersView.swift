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
    
    init(game: Game) {
        self.game = game
    }
    
    
    
    
    
    
    var body: some View {
        
        
        
        ZStack {
            switch game.players.count {

            case 1:
                VStack {
                    HStack() {
                        Spacer()
                        CirclePicView(player: game.players[0], game: game)
                        Spacer()

                    }
                    .padding(.top, 4)
                    .background(Color.red)
                    
                    Spacer()


                }

            case 2:
                VStack {
                    Text("2")

                }


            case 3:
                ZStack {

                    Text("3")

                }

            case 4:
                ZStack {
                    Text("4")

                }

            case 5:
                ZStack {
                    Text("5")

                }

            case 6:
                ZStack {
                    Text("6")


                }

            case 7:
                ZStack {
                    Text("7")


                }


            default:
                Text("NOT POSSIBLE")


            }

        }
        .background(Color.cyan)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        VStack {
//
//            HStack() {
//                Spacer()
//                if game.players.count > 0 {
//                    CirclePicView(player: game.players[0], game: game)
//                }
//
//                if game.players.count > 3 {
//                    Spacer()
//                    CirclePicView(player: game.players[3], game: game)
//                }
//
//
//                if game.players.count > 4 {
//                    Spacer()
//                    CirclePicView(player: game.players[4], game: game)
//                }
//
//                Spacer()
//
//
//            }
//            .padding(.top, 4)
//
//
//            Spacer()
//            HStack() {
//
//                VStack{
//
//                    Spacer()
//
//                    if game.players.count > 5 {
//                        CirclePicView(player: game.players[5], game: game)
//                        Spacer()
//                    }
//
//                    if game.players.count > 1 {
//                        CirclePicView(player: game.players[1], game: game)
//                    }
//
//                    Spacer()
//
//                }
//
//
//                Spacer()
//                VStack {
//                    Spacer()
//                    if game.players.count > 6 {
//                        CirclePicView(player: game.players[6], game: game)
//                        Spacer()
//                    }
//
//                    if game.players.count > 2 {
//                        CirclePicView(player: game.players[2], game: game)
//                    }
//
//                    Spacer()
//                }
//
//            }
//
//
//            Spacer()
//
//
//        }
        
        
    }
}

struct PlayersView_Previews: PreviewProvider {
    //@ObservedObject var game = DataHolder.controller.game
    
    static var previews: some View {
        PlayersView(game: DataHolder.controller.game)
    }
}
