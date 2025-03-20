//
//  LoginView.swift
//  ToDoRCat
//
//  Created by Akshayan on 2025-03-20.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var user1 = ""
    @State private var pass1 = ""
    @State private var existingUser = false
    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $user1)
                    .padding(.leading)
                    .frame(width: 340, height: 50, alignment: .leading)
                    .border(.green)
                    .cornerRadius(5.0)
                    .padding(.leading)
                SecureField("Password", text: $pass1)
                    .padding(.leading)
                    .frame(width: 340, height: 50, alignment: .leading)
                    .border(.green)
                    .cornerRadius(5.0)
                    .padding(.leading)
               
                Button(action: {
                    signin()
                    existingUser.toggle()
                    
                    
                }, label: {
                    Text("Login")
                })
                .padding(.top)

            }
            
        }
        .fullScreenCover(isPresented: $existingUser) {
            ListUIView()
        }
        .navigationTitle("Welcome Back! ")
        
        
        
            
        
    }
    func signin() {
        Auth.auth().signIn(withEmail: user1, password: pass1) { authResult, error in
            if let error = error {
                print(error)
            }
            if let authResult = authResult {
                print(authResult.user.uid)
                
                
            }
          
        }
    }
}

#Preview {
    LoginView()
}
