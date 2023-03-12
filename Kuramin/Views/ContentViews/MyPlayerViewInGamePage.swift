//
//  MyPlayerViewInGamePage.swift
//  Kuramin
//
//  Created by MD. Zahed on 12/03/2023.
//

import SwiftUI

struct MyPlayerViewInGamePage: View {
    @ObservedObject var me: Player
    @State var coins: Int
    @State var str = ""
    
    init(me: Player) {
        self.me = me
        self.coins = me.coins
    }
    
    
    var body: some View {
        ZStack {
            
//            CardView()
//                .padding(.bottom, 80)
            
                
            
            Rectangle()
                .fill(Color.cyan)
                .frame(width: 350, height: 40)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 0.5)
                )
            
                .shadow(radius: 20)
                .frame(width: 300, height: 40)
            
            
            
            
            ZStack {
                
                
                
                
                if me.isNotDummy {
                    
                    HStack {
                        Image("coins_30")
                        
                        Text("\(coins)\(str)")
                        
                        
                        Spacer()
                        
                    }
                    
                    
                    
                    HStack {
                        Spacer()
                        CirclePicView(player: me)
                        Spacer()
                        
                    }

                    


                }
            }
            
            
            
        }
        .frame(width: 350, height: 40)
        .shadow(radius: 200)

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
        MyPlayerViewInGamePage(me: DataHolder.controller.game.me)
    }
}
