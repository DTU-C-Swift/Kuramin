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
            
            VStack {
                
                HStack() {
                    Spacer()
                    VStack {
                        Image("person_34")
                            .frame(width: 60, height: 60)
                            .scaleEffect(1.5)
                            .clipShape(Circle())
                            .overlay{
                                Circle().stroke(Color.white, lineWidth: 4)
                            .shadow(radius: 7)
        
                        }
                        Text("Player1")
                            .font(.footnote)
                            .foregroundColor(Color.white)

                    }
                        
                    Spacer()
                
                }
                
                
                Spacer()
                HStack() {
            
                    VStack {
                        Image("person_34")
                            .frame(width: 60, height: 60)
                            .scaleEffect(1.5)
                            .clipShape(Circle())
                            .overlay{
                                Circle().stroke(Color.white, lineWidth: 4)
                            .shadow(radius: 7)
        
                        }
                        Text("Player2")
                            .font(.footnote)
                            .foregroundColor(Color.white)

                    }
                    Spacer()
                    
                    VStack {
                        Image("person_34")
                            .frame(width: 60, height: 60)
                            .scaleEffect(1.5)
                            .clipShape(Circle())
                            .overlay{
                                Circle().stroke(Color.white, lineWidth: 4)
                            .shadow(radius: 7)
        
                        }
                        Text("Player3")
                            .font(.footnote)
                            .foregroundColor(Color.white)

                    }
                
                }
                

                
                Spacer()
                
                
                HStack() {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(Color.cyan)
                            .frame(width: 300, height: 40)
                            .cornerRadius(20)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 0.5)
                                )
                        
                            .shadow(radius: 20)

                            
                        
                        Image("person_34")
                            .frame(width: 60, height: 60)
                            .scaleEffect(1.5)
                            .clipShape(Circle())
                            .overlay{
                                Circle().stroke(Color.white, lineWidth: 4)
                            .shadow(radius: 7)
                            
                        }
                    }
                    Spacer()
                
                }
                
                
            }
            
            
            

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
