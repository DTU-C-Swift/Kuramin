//
//  MenuPopup.swift
//  Kuramin
//
//  Created by MD. Zahed on 04/03/2023.
//

import SwiftUI

struct MenuPopup: View {
    @Environment(\.presentationMode) var pm: Binding<PresentationMode>
    
    
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
//                    .background(.red)
                    
                    
                }
                
                Spacer()
            }
            
        }
        
        
        
    }
}

struct MenuPopup_Previews: PreviewProvider {
    static var previews: some View {
        MenuPopup()
    }
}
