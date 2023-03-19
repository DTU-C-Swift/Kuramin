//
//  SignUpPage.swift
//  Kuramin
//
//  Created by Numan Bashir on 19/03/2023.
//

import SwiftUI
import Firebase

struct SignUpPage: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var firstName: String = ""
    @State var secondName: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "mail")
                TextField("Email", text: $email)
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
                TextField("First Name", text: $firstName)
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
                TextField("Second Name", text: $secondName)
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
                
            }
            
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    // Handle sign-up error
                    print(error.localizedDescription)
                } else if let result = result {
                    // Sign-up successful
                    print("Signed up as \(result.user.email ?? "")")
                }
            }
    }
    
}

struct SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPage()
    }
}
