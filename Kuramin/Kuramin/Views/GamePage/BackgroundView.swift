//
//  BackgroundView.swift
//  Kuramin
//
//  Created by MD. Zahed on 01/03/2023.
//

import SwiftUI

struct BackgroundView: View {
    var controller: Controller
    @ObservedObject var game: Game
    @State private var dots: String = ""


    
    init(controller: Controller, game: Game) {
        self.controller = controller
        self.game = game
    }
    
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
            
            
            VStack {
                Spacer()
                Spacer()
                
                if game.cardOnBoard != nil {
                    Image(game.cardOnBoard!.toString())
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
                        .frame(width: 60, height: 100)
                }
                
                
                // Waiting for players to join msg
                if game.id == Util.NOT_SET || game.id == "" {
                    VStack {
                        ZStack {
                            Text("Waiting for players to join\(dots)")
                                .frame(width: 235, alignment: .leading)
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                                                
                    }
                    .onAppear {
                        animateDots()
                    }
                }
                
                Spacer()
                Spacer()
                Spacer()
                
            }
            
            
            
            VStack {
                Spacer()
                Spacer()
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
                
                Spacer()
                Spacer()
                Spacer()
            }
        }
        

    }
    
    
    
    func animateDots() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            
            dots += "."
            if dots.count > 3 { dots = "" }
        }
    }
    
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(controller: DataHolder.controller, game: DataHolder.controller.game)
    }
}
