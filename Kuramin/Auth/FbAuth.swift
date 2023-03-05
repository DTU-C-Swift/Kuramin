//
//  FbAuth.swift
//  Kuramin
//
//  Created by MD. Zahed on 04/03/2023.
//

import SwiftUI
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit




struct FbAuth: View {
    var width: CGFloat
    var height: CGFloat
    
    init(width: Int, height: Int) {
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }
    
    var body: some View {
        login().frame(width: width, height: height)
    }
}

//struct FbAuth_Previews: PreviewProvider {
//    static var previews: some View {
//        FbAuth()
//    }
//}




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
            DataHolder.controller.loginBtnClicked = true
            
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            if AccessToken.current != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { (res, er) in
                    
                    if er != nil {
                        
                        print(er?.localizedDescription)
                        return
                    }
                    
                    print("Login with facebook success")
                    DataHolder.controller.loginBtnClicked = false
                    DataHolder.controller.isLoggedIn = true
                }
            }
        }
        
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            try! Auth.auth().signOut()
            //DataHolder.controller.isLoggedIn = false
            
        }
    }
    

    
}



