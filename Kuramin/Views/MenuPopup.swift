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
                
                if controller.service.isUserloggedIn_viaFacebook() {
                    
                    FbAuth(width: 80, height: 50)
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

struct MenuPopup_Previews: PreviewProvider {
    static var previews: some View {
        MenuPopup()
    }
}
