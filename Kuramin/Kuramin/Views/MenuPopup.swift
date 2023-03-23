//
//  MenuPopup.swift
//  Kuramin
//
//  Created by MD. Zahed on 04/03/2023.
//

import Firebase

import SwiftUI

struct MenuPopup: View {
    @Environment(\.presentationMode) var pm: Binding<PresentationMode>
    @ObservedObject var controller = DataHolder.controller
    @EnvironmentObject var navState: NavState
    @State var isPresentingConfirmation = false
    
    
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        pm.wrappedValue.dismiss()
                        
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .padding(.top, 20)
                    .font(.system(size: 35))
                    
                    
                }
                
                Spacer()
                
                //                if controller.service.isUserloggedIn_viaFacebook() {
                //
                //                    FbAuth(width: 200, height: 50)
                //                        .cornerRadius(16)
                //                        .shadow(radius: 1, x: 0, y: 1)
                //                }
                
                
                
                
                Button(action: {
                    isPresentingConfirmation = true
                
                }) {
                    Text("Log out")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(.blue)
                        .cornerRadius(15)
                        .shadow(radius: 1, x: 0, y: 1)
                    
                }.confirmationDialog("Are you sure?", isPresented: $isPresentingConfirmation) {
                    
                    Button("Confirm", role: .destructive) {
                        controller.logOut()
                        
                    }
                    
                }
                
                
                
                
                Spacer()
                
                
                
            }
            
        }
        .onChange(of: controller.isLoggedIn) { newValue in
            if !newValue {
                navState.state = ""
                pm.wrappedValue.dismiss()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .persistentSystemOverlays(.hidden)

        
        
        
    }
    
    
    
    
}

struct MenuPopup_Previews: PreviewProvider {
    static var previews: some View {
        MenuPopup()
    }
}
