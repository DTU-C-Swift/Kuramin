//
//  TestVIew.swift
//  Kuramin
//
//  Created by MD. Zahed on 15/03/2023.
//

import SwiftUI

struct TestVIew: View {
    //@ObservedObject var gameTest = GameTest()
    @ObservedObject var gameTest = GameTestMain()

    
    
    
    
    var body: some View {
        
        VStack {
            
            if gameTest.testPassed {
                Text("All test passed")
            } else {
                Text("Test Running")
            }

        }
        .onAppear {
            
            gameTest.main()
        }
    }
    
}




struct TestVIew_Previews: PreviewProvider {
    static var previews: some View {
        TestVIew()
    }
}
