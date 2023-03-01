//
//  GamePage_ProfileView.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import SwiftUI

struct CirclePicView: View {
    var playerName: String
    var imageName: String
    
    init(playerName: String, imageName: String) {
        self.playerName = playerName
        self.imageName = imageName
    }
    
    
    var body: some View {
        
        VStack(spacing: 1) {
            Image(imageName)
                .frame(width: 60, height: 60)
                .scaleEffect(1.5)
                .clipShape(Circle())
                .overlay{
                    Circle().stroke(Color.white, lineWidth: 4)
                .shadow(radius: 7)
                
            }
            Text(playerName)
                .font(.footnote)
                .foregroundColor(Color.white)
                

        }
    
        
    }
}

//struct GamePage_ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        GamePage_ProfileView("person_34", "PlayerName")
//    }
//}
