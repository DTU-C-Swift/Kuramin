//
//  GamePageView.swift
//  Kuramin
//
//  Created by Numan Bashir on 16/02/2023.
//

import SwiftUI

struct GamePageView: View {
    @State private var isAnimating = false
    
    
    var body: some View {
        ZStack {
        
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.cyan, Color.blue, Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: .trailing)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 150)
                .strokeBorder(Color.cyan, lineWidth: 35)
                .scaleEffect(0.8)
            RoundedRectangle(cornerRadius: 150)
                .strokeBorder(Color.black, lineWidth: 30)
                .scaleEffect(0.8)
                .shadow(color: Color.cyan, radius: 10, x: 0, y: 5)
            
            

        }
        
        
//        .onAppear {
//            withAnimation(Animation.easeIn(duration: 1).repeatForever(autoreverses: true)) {
//                isAnimating.toggle()
//            }
//        }
        

    }
    
    private var lineWidth: CGFloat {
        isAnimating ? 10 : 30
    }
}


struct GamePageView_Previews: PreviewProvider {
    static var previews: some View {
        GamePageView()
        
        
    }
}
