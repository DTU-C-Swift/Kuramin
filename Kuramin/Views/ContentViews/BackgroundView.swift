//
//  BackgroundView.swift
//  Kuramin
//
//  Created by MD. Zahed on 01/03/2023.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: [Color.black, Color.cyan, Color.blue, Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: .trailing)
            .ignoresSafeArea(.all)

        RoundedRectangle(cornerRadius: 150)
            .strokeBorder(Color.cyan, lineWidth: 35)
            .scaleEffect(0.68)
            .padding(.top, 30)
        RoundedRectangle(cornerRadius: 150)
            .strokeBorder(Color.black, lineWidth: 30)
            .scaleEffect(0.7)
            .shadow(color: Color.cyan, radius: 10, x: 0, y: 5)
            .padding(.top, 30)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
