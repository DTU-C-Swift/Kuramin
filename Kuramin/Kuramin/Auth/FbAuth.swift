//
//  FbAuth.swift
//  Kuramin
//
//  Created by MD. Zahed on 04/03/2023.
//
// Most of the code in file is from Facebook Developer




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
    
    func logOutFb() {
        LoginManager().logOut()
    }
    
    func somethingWentWrong() {
        self.logOutFb()
        DataHolder.controller.bufferState = Util.FAILED

    }
    
    
    
    
    
    class loginCoordinator: NSObject, LoginButtonDelegate {
        var p = Printer(tag: "FbAuth", displayPrints: true)

        
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            
            if error != nil {
                self.p.write("Error in login button: \(error?.localizedDescription)")
                login().somethingWentWrong()
                return
            }
            
            if AccessToken.current != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                DataHolder.controller.bufferState = Util.PROGRESSING
                
                Auth.auth().signIn(with: credential) { (res, er) in
                    if er != nil {
                        self.p.write("Error signing in: \(er?.localizedDescription)")
                        login().somethingWentWrong()
                        return
                    }
                    
                    self.p.write("Login with Facebook success")
                    
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
                                    self.p.write("Facebook login fully done, and create_or_update_user has been called")
                                    DataHolder.controller.create_or_update_user(userImage: image)
                                }
                                
                                else {
                                    self.p.write("Image is nil")
                                    login().somethingWentWrong()

                                }
                                
                            }.resume()
                        }
                        
                        else {
                            self.p.write("The result of GraphRequest.start is nil")
                            login().somethingWentWrong()

                        }
                        
                    }
                    
                    DataHolder.controller.bufferState = Util.SUCCEDED
                }
            }
            else {
                self.p.write("AccessToken is nil")
                //login().somethingWentWrong()

            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            try! Auth.auth().signOut()
        }
        

    }
    
    



    
}



