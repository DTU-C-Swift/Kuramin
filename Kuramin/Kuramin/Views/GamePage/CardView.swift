//
//  CardView.swift
//  Kuramin
//
//  Created by MD. Zahed on 12/03/2023.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        HStack {
            Image("card1")
                .resizable()
                .frame(width: 50, height: 73)
                .padding(2)
            
            Image("card2")
                .resizable()
                .frame(width: 50, height: 73)
                .padding(2)

            Image("card1")
                .resizable()
                .frame(width: 50, height: 73)
                .padding(2)
            
            Image("card2")
                .resizable()
                .frame(width: 50, height: 73)
                .padding(2)

        


        }

    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
