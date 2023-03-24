//
//  CardView.swift
//  Kuramin
//
//  Created by MD. Zahed on 12/03/2023.
//

import SwiftUI

struct CardView: View {
    
    var card: Card
    let width = 60.0
    let height = 130.0
    
    init(card: Card) {
        self.card = card
    }
    
    
    var body: some View {
        HStack {
            Image(card.toString())
                .resizable()
                .scaledToFit()
                .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
        }
        .background(.red)
        .frame(width: width, height: height)
    }

    
    
    
//    var body: some View {
//        HStack {
//            Image(card.toString())
//                .resizable()
//                .scaledToFit()
//                .scaleEffect(0.3)
//                .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
//        }
//
//    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(suit: "H", value: 11))
    }
}
