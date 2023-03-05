//
//  ProgressBar.swift
//  Kuramin
//
//  Created by MD. Zahed on 05/03/2023.
//

import SwiftUI

struct ProgressBar: View {    
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.cyan))
                .scaleEffect(3)
                .foregroundColor(.cyan)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar()
    }
}
