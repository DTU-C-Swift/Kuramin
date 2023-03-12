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
        
        VStack {
            ScrollView {
                Text("""
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas mattis, metus non lacinia venenatis, purus risus sollicitudin ante, eu mattis mi enim lobortis dolor. Quisque fringilla ut neque et fringilla. Maecenas varius pharetra dui, eu venenatis urna blandit ac. In hac habitasse platea dictumst. Curabitur sed purus pulvinar, pharetra augue ac, lobortis magna. Nam nec arcu et nisl semper mattis. Ut ut odio volutpat, finibus augue sit amet, auctor purus.
                    """)
                .padding()
                .frame(width: 600)
            }
            
            Spacer()
            HStack {
                Button(action: {
                    pm.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
                .frame(width: 20, height: 20)
                Spacer()
            }
        }.padding(.bottom, 10)
        
        
        
        
        
        
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
