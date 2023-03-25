//
//  TestVIew.swift
//  Kuramin
//
//  Created by MD. Zahed on 15/03/2023.
//

import SwiftUI

struct TestVIew: View {
    //@ObservedObject var gameTest = GameTest()
    @ObservedObject var gameTest1 = GameTest1()
    @ObservedObject var gameTest2 = GameTest2()
    @ObservedObject var gameTest3 = GameTest2()



    
    
    
    
    var body: some View {
        
        VStack {
            
            if gameTest1.testPassed  {
                Text("GameTest1 passed")
                    .background(.green)
                
            } else {
                Text("GameTest1 running")
                    .background(.yellow)

            }
            
            if gameTest2.testPassed {
                Text("GameTest2 passed")
                    .background(.green)

                
            } else {
                Text("GameTest2 running")
                    .background(.yellow)

            }
            
            
            if gameTest3.testPassed {
                Text("GameTest3 passed")
                    .background(.green)

                
            } else {
                Text("GameTest3 running")
                    .background(.yellow)

            }
            
            

        }
        .onAppear {
            
            gameTest1.run()
            gameTest2.run()
            gameTest3.run()
        }
    }
    
}




struct TestVIew_Previews: PreviewProvider {
    static var previews: some View {
        TestVIew()
    }
}
