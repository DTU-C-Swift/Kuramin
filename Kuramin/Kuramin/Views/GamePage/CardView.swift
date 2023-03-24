//
//  CardView.swift
//  Kuramin
//
//  Created by MD. Zahed on 12/03/2023.
//

import SwiftUI

struct CardView: View {
    
    var card: Card
    
    init(card: Card) {
        self.card = card
    }
    
    
    var body: some View {
        HStack {
            Image("C1")
                .resizable()
                .frame(width: 50, height: 73)
                .padding(2)
            
            Image("C2")
                .resizable()
                .frame(width: 50, height: 73)
                .padding(2)

        }

    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(suit: "H", value: 11))
    }
}
