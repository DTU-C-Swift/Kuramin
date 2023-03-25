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
    @ObservedObject var subTest = SubGameTest()


    
    
    
    
    var body: some View {
        
        VStack {
            
            if gameTest.testPassed  {
                Text("MainTest passed")
            }
            
            if subTest.testPassed {
                Text("SubTest passed")
            }
            
            if !subTest.testPassed && !gameTest.testPassed {
                Text("Test Running")
            }

        }
        .onAppear {
            
            gameTest.main()
            subTest.main()
        }
    }
    
}




struct TestVIew_Previews: PreviewProvider {
    static var previews: some View {
        TestVIew()
    }
}
