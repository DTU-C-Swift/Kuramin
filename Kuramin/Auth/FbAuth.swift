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
    var p = Printer(tag: "FbAuth", displayPrints: true)
    
    
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
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            
            if error != nil {
                login().p.printt("Error in login button: \(error?.localizedDescription)")
                return
            }
            
            if AccessToken.current != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                DataHolder.controller.showBuffer = true
                Auth.auth().signIn(with: credential) { (res, er) in
                    if er != nil {
                        login().p.printt("Error signing in: \(er?.localizedDescription)")
                        return
                    }
                    
                    login().p.printt("Login with Facebook success")
                    
                    // Get user's profile picture
                    let graphRequest = GraphRequest(graphPath: "me/picture", parameters: ["width": "100", "height": "100", "redirect": "false"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get)
                    
                    
                    
                    graphRequest.start { (connection, result, error) in
                        if error == nil, let result = result as? [String:Any], let data = result["data"] as? [String:Any], let url = data["url"] as? String {
                            
                            // Download user's profile picture
                            URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
                                if let data = data {
                                    let image = UIImage(data: data)
                                    // Use the image as needed
                                    //DataHolder.controller.image = image
//                                    if let image = image {
//                                        DataHolder.controller.game.me.image = image
//                                    }
                                    login().p.printt("Facebook login fully done, and create_or_update_user has been called")
                                    DataHolder.controller.service.create_or_update_user(userImage: image)
                                }
                                
                                else {login().p.printt("Image is nil")}
                                
                            }.resume()
                        }
                        
                        else {
                            login().p.printt("The result of GraphRequest.start is nil")
                        }
                        
                    }
                    
                    DataHolder.controller.showBuffer = false
                }
            }
            else {
                login().p.printt("AccessToken is nil")
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            try! Auth.auth().signOut()
        }
    }
    
    
    func logOutFb() {
        LoginManager().logOut()

    }


    
}



