//
//  MyPlayerViewInGamePage.swift
//  Kuramin
//
//  Created by MD. Zahed on 12/03/2023.
//

import SwiftUI

struct MyPlayerViewInGamePage: View {
    @ObservedObject var me: Player
    @ObservedObject var game: Game
    @State var coins: Int
    @State var str = ""
    var fameWidth = UIScreen.main.bounds.maxX * 0.6

    
    init(me: Player, game: Game) {
        self.me = me
        self.game = game
        self.coins = me.coins
    }
    
    
    var body: some View {
        
        ZStack {
            
            VStack {
                Spacer()
                CardsView(me: me)
                Spacer()
            }
            
            
            
            VStack {
                
                Spacer()
                ZStack {
                    
                    
                    Rectangle()
                        .fill(Color.cyan)
                        .frame(width: fameWidth, height: 40)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 0.5)
                        )
                    
                        .shadow(radius: 20)
                        .frame(width: fameWidth, height: 40)
                    
                    
                    
                    
                    ZStack {
                        
                        
                        HStack {
                            Image("coins_30")
                            Text("\(coins)\(str)")
                            Spacer()
                            
                        }
                        
                        
                        HStack {
                            Spacer()
                            CirclePicView(player: me, game: game)
                            Spacer()
                            
                        }
                    }
                    
                    
                    
                }
                
            }
            
            
            
            
        }
        //.background(.red)

        
        //
        .frame(width: fameWidth, height: 180)
        .shadow(radius: 20)
        
        .onChange(of: me.coins) { newValue in
            if newValue >= 1000000 {
                coins = newValue/1000
                str = "K"
                
            } else {
                coins = newValue
                str = ""
            }
            
        }
    }
}

struct MyPlayerViewInGamePage_Previews: PreviewProvider {
    static var previews: some View {
        MyPlayerViewInGamePage(me: DataHolder.controller.game.me, game: DataHolder.controller.game)
    }
}
