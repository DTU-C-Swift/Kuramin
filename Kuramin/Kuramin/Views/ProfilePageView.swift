//
//  ProfilePageView.swift
//  Kuramin
//
//  Created by Numan Bashir on 23/02/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct ProfilePageView: View {
    let statsTitles = ["Matches", "Wins", "Win Rate", "Losses", "Loss Rate"]
    let statsValues = ["100", "60", "60%", "40", "40%"]
    var dummyCoins = 123
    
    @Environment(\.presentationMode) var pm: Binding<PresentationMode>
    //@ObservedObject var controller = DataHolder.controller
    @ObservedObject var controller = DataHolder.controller
    @ObservedObject var profile = DataHolder.controller.profile
    @EnvironmentObject var navState: NavState
    @State private var fullName = ""
    @State private var userCoins = 0
    
    
    var body: some View {
        
        
        
        ZStack(alignment: .topTrailing) {
            
            VStack {
                
                Image(uiImage: profile.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding(.top, 50)
                    .shadow(radius: 10)
                
                VStack {
                    if profile.fullName != Util.NOT_SET {
                        Text(profile.fullName)
                            .font(.title)
                            .bold()
                    }
                        
                    HStack {
                        Image("cash")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("\(profile.coins)")
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
        .onAppear {
            if let id = Auth.auth().currentUser?.uid {
                controller.profile.setId(pid: id)
            }
            
            getNameData()
            
        }
        
        
        
    }
    
    func getNameData() {
        let db = Firestore.firestore()
        
        db.collection("users").document(controller.profile.id)
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
                print("Current data: \(data)")
                
                do {
                    let dbUser = try document.data(as: DbUser.self)
                    controller.userService.downloadImg(player: profile)
                    controller.profile.updateMe(dbUser: dbUser)
                    
                }
                catch {
                    print("getUser failed: \(data)")
                    
                }
            }
    }
    
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
