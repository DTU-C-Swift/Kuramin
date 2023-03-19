//
//  SignUpPage.swift
//  Kuramin
//
//  Created by Numan Bashir on 19/03/2023.
//

import SwiftUI

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
}

struct SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPage()
    }
}
