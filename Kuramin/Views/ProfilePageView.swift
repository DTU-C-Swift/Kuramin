//
//  ProfilePageView.swift
//  Kuramin
//
//  Created by Numan Bashir on 23/02/2023.
//

import SwiftUI

struct ProfilePageView: View {
    var body: some View {
        
        VStack {
            Text("Test")
                .padding()
            
            ZStack {
                HStack {
                    Text("Test1")
                    
                    Text("Test2")
                }
            }

            
        }
        
        
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
