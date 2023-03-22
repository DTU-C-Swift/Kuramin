//
//  BackgroundView.swift
//  Kuramin
//
//  Created by MD. Zahed on 01/03/2023.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.cyan, Color.blue, Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: .trailing)
                .ignoresSafeArea(.container)

            RoundedRectangle(cornerRadius: 100)
                .strokeBorder(Color.cyan, lineWidth: 30)
                .scaleEffect(1)
                .frame(width: UIScreen.main.bounds.width * 0.68, height: UIScreen.main.bounds.height * 0.6, alignment: .center)
                .padding(.top, 30)
            RoundedRectangle(cornerRadius: 100)
                .strokeBorder(Color.black, lineWidth: 30)
                .scaleEffect(1)
                .frame(width: UIScreen.main.bounds.width * 0.68, height: UIScreen.main.bounds.height * 0.6, alignment: .center)
                .shadow(color: Color.cyan, radius: 10, x: 0, y: 5)
                .padding(.top, 30)
            
            
            
            HStack {
                Spacer()
                Spacer()
                Spacer()
                VStack {
                    Text("Rewards")
                    Text("1: 100")
                    Text("2: 50 ")
                    Text("3: 25 ")

                }.foregroundColor(.white)
                Spacer()
            }
            
            
        }
        

    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
