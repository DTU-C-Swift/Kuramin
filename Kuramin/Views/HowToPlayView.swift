//
//  HowToPlayView.swift
//  Kuramin
//
//  Created by Numan Bashir on 12/03/2023.
//

import SwiftUI

struct HowToPlayView: View {
    
    @Environment(\.presentationMode) var pm: Binding<PresentationMode>
    
    var body: some View {
        Button(action: {
            pm.wrappedValue.dismiss()
            
        }) {
            Image(systemName: "chevron.backward")
                .foregroundColor(.black)
        }
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
