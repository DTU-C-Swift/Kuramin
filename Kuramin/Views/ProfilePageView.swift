//
//  ProfilePageView.swift
//  Kuramin
//
//  Created by Numan Bashir on 23/02/2023.
//

import SwiftUI

struct ProfilePageView: View {
    let statsTitles = ["Matches", "Wins", "Win Rate", "Losses", "Loss Rate"]
    let statsValues = ["100", "60", "60%", "40", "40%"]
    var dummyCoins = 123
    
    @Environment(\.presentationMode) var pm: Binding<PresentationMode>
    @ObservedObject var controller = DataHolder.controller
    @EnvironmentObject var navState: NavState
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            VStack {
                
                Image("person_34")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding(.top, 50)
                    .shadow(radius: 10)
                
                VStack {
                    Text("Player Name")
                        .font(.title)
                        .bold()
                    HStack {
                        Image("cash")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("\(dummyCoins)")
                            .font(.subheadline)
                    }
                    
                    // Stats grid
                    LazyVGrid(columns: [GridItem(.flexible(), alignment: .leading)], spacing: 5) {
                        ForEach(0..<statsTitles.count, id: \.self) { index in
                            HStack() {
                                Text(statsTitles[index])
                                    .font(.headline)
                                Spacer()
                                Text(statsValues[index])
                                    .font(.subheadline)
                            }
                            .padding(.horizontal, 50)
                            .padding(.vertical, 5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 175)
                    
                }
                .padding(.horizontal, 50)
                
                Spacer()
                
                
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        pm.wrappedValue.dismiss()
                        
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .padding(.top, 30)
                    .font(.system(size: 35))
             
                    
                }
                
                Spacer()
                
            }
            
        }.onChange(of: controller.isLoggedIn) { newValue in
            if !newValue {
                navState.state = ""
                pm.wrappedValue.dismiss()
            }
        }
        
        
        
        
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
