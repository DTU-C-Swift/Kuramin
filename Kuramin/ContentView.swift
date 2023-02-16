//
//  ContentView.swift
//  Kuramin
//
//  Created by Numan Bashir on 16/02/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            VStack {
                NavigationLink(destination: MainPageView()) {
                    HStack {
                        Image(systemName: "applelogo")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        Text("Login with Apple")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(Color.black)
                    .cornerRadius(16)
                    .shadow(radius: 4, x: 0, y: 4)
                }
                
                NavigationLink(destination: MainPageView()) {
                    HStack {
                        Image(systemName: "book.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        Text("Login with Facebook")
                            .font(.system(size: 24, weight:
                                    .semibold))
                                    .foregroundColor(.white)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(Color.blue)
                    .cornerRadius(16)
                    .shadow(radius: 4, x: 0, y: 4)
                }
                
                NavigationLink(destination: MainPageView()) {
                    HStack {
                        Image(systemName: "tree")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                        Text("Login with Google")
                            .font(.system(size: 24, weight:
                                    .semibold))
                                    .foregroundColor(.black)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 4, x: 0, y: 4)
                }
                
            }
            .padding()
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}

struct MainPageView: View {
    var body: some View {
        
        VStack {
            NavigationLink(destination: GamePageView()) {
                Text("Start New Game")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 4, x: 0, y: 4)
            }
            
            
            
            Text("Join Game")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 4, x: 0, y: 4)
            
            Text("How To Play?")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 4, x: 0, y: 4)
        
        }
        
    }
}
