//
//  SignUpPage.swift
//  Kuramin
//
//  Created by Numan Bashir on 19/03/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SignUpPage: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var fullName: String = ""
    @State var coins: Int = 500
    
    var controller = DataHolder.controller
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "mail")
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                Spacer()
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.black)
            )
            .padding(.vertical, 2)
            .padding(.horizontal, 200)
            
            HStack {
                Image(systemName: "lock")
                TextField("Password", text: $password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                Spacer()
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.black)
            )
            .padding(.vertical, 2)
            .padding(.horizontal, 200)
            
            HStack {
                Image(systemName: "person")
                TextField("Full Name", text: $fullName)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                Spacer()
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.black)
            )
            .padding(.vertical, 2)
            .padding(.horizontal, 200)
            
            Button("Sign Up") {
                signUp()
            }
            
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let result = result {
                print("Signed up as \(result.user.email ?? "")")
                let changeRequest = result.user.createProfileChangeRequest()
                changeRequest.displayName = "\(fullName)"
                changeRequest.commitChanges { error in
                    if let error = error {
                        // Handle error
                        print(error.localizedDescription)
                    } else {
                        print("User profile updated with name: \(result.user.displayName ?? "")")
                        let db = Firestore.firestore()
                        let userDocRef = db.collection("users").document(result.user.uid)
                        var dbUser = DbUser(uid: result.user.uid, fullName: result.user.displayName!, coins: 500)
                        do {
                            try db.collection("users").document(result.user.uid).setData(from: dbUser)
                            
                        } catch let error {
                            print("Error creating user in db: (error)")
                        }
                    }
                }
            }
        }
    }
    
}

struct SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPage()
    }
}

