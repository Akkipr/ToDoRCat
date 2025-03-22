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
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Welcome Back!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                VStack(spacing: 15) {
                    TextField("Email", text: $user1)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $pass1)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    signin()
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                        .shadow(radius: 5)
                }
                .padding(.top, 20)
                .fullScreenCover(isPresented: $existingUser) {
                    ListUIView()
                }
            }
        }
    }
    
    func signin() {
        Auth.auth().signIn(withEmail: user1, password: pass1) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                existingUser = true
            }
        }
    }
}

#Preview {
    LoginView()
}
