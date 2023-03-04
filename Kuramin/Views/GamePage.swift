//
//  GamePageView.swift
//  Kuramin
//
//  Created by Numan Bashir on 16/02/2023.
//

import SwiftUI
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


struct GamePage: View {
    @State private var isAnimating = false
    @Environment(\.presentationMode) var pm: Binding<PresentationMode>
    
    
    //@EnvironmentObject var controller: Controller
    var controller: Controller
    
    init() {
        self.controller = DataHolder.controller
        controller.game.addDummyPlayers()
        
    }
    
    
    var body: some View {
        login().frame(width: 100, height: 50)

        
//        ZStack {
//
//
//            BackgroundView()
//
//            VStack {
//
//                HStack() {
//                    Spacer()
//
//                    CirclePicView(player: controller.game.players[0])
//                        .padding(.top, 3)
//
//                    Spacer()
//
//                }
//
//
//                Spacer()
//                HStack() {
//
//                    CirclePicView(player: controller.game.players[1])
//                    Spacer()
//
//                    CirclePicView(player: controller.game.players[2])
//
//                }
//
//
//                Spacer()
//                HStack() {
//
//                    Button(action: {
//                        //                        controller.game.players[0].name = "New Name"
//                        //                        pm.wrappedValue.dismiss()
//                        print("Hello")
//
//
//                    }) {
//                        Image(systemName: "chevron.backward")
//                            .foregroundColor(.white)
//                    }
//
//                    Button(action: {
//                        controller.service.fetchData()
//                        controller.service.intializeGame(p: controller.game.players[0])
//
//                    }) {
//                        Image(systemName: "chevron.backward")
//                            .foregroundColor(.white)
//                    }
//
//
//                    Spacer()
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.cyan)
//                            .frame(width: 300, height: 40)
//                            .cornerRadius(20)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 20)
//                                    .stroke(Color.black, lineWidth: 0.5)
//                            )
//
//                            .shadow(radius: 20)
//
//                        CirclePicView(player: controller.game.me)
//
//                    }
//                    Spacer()
//                }
//
//
//            }
//
//
//        }
//        .navigationBarBackButtonHidden(true)
        //        .onAppear {
        //            controller.game.addDummyPlayers()
        //        }
        
        
    }
    
    
    
}



struct GamePageView_Previews: PreviewProvider {
    static var previews: some View {
        GamePage()
        
        
    }
}




struct login : UIViewRepresentable {
    
    typealias UIViewType = FBLoginButton
    typealias Coordinator = loginCoordinator
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> FBLoginButton {
        let button = FBLoginButton()
        button.delegate = context.coordinator
        return button
    }
    
    
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {
        print("View updated")
    }
    
    class loginCoordinator: NSObject, LoginButtonDelegate {
        
        
        // Implementation of login button delegate methods
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if error != nil {
                print(error?.localizedDescription, ("here2"))
                return
            }
            
            if AccessToken.current != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { (res, er) in
                    
                    if er != nil {
                        
                        print(er?.localizedDescription, ("here1"))
                        return
                    }
                    
                    print("Success")
                }
            }
        }
        
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            try! Auth.auth().signOut()
            
        }
    }
    

    
}
