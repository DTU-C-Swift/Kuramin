//
//  GamePage_ProfileView.swift
//  Kuramin
//
//  Created by MD. Zahed on 28/02/2023.
//

import SwiftUI

struct CirclePicView: View {
//    @Binding var playerName: String
//    @Binding var imageName: String
    
//    init(playerName: String, imageName: String) {
//        self.playerName = playerName
//        self.imageName = imageName
//    }
    
    @ObservedObject var player: Player
    
    init(player: Player) {
        self.player = player
    }
    
    
    var body: some View {
        
        VStack(spacing: 1) {
            Image(player.image)
                .frame(width: 60, height: 60)
                .scaleEffect(1.5)
                .clipShape(Circle())
                .overlay{
                    Circle().stroke(Color.white, lineWidth: 4)
                .shadow(radius: 7)
                
            }
            Text(player.name)
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
