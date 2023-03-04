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
        
        VStack {
            Button {
                pm.wrappedValue.dismiss()
                
            } label: {
                Image(systemName: "xmark")
            }

            
        }
        
        
        
    }
}

struct MenuPopup_Previews: PreviewProvider {
    static var previews: some View {
        MenuPopup()
    }
}
