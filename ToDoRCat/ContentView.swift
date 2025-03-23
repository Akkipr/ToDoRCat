//
//  ContentView.swift
//  ToDoRCat
//
//  Created by Akshayan on 2025-03-20.
//

import SwiftUI
import SwiftData
import FirebaseAuth

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    

    @State private var user = ""
    @State private var password = ""
    @State private var newUser = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationView{
            
            ZStack {
                    
                    
                LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                
                VStack(spacing: 10) {
                    
                    
                    Image("someupload")
                        .resizable()
                        .scaledToFit()
                        .frame(width:200, height:200)
                    
                    Text("Welcome New User!")
                        .padding(.top, 70)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .padding(.bottom, 30)
                
                    
                    
                    VStack(spacing: 15) {
                        TextField("Email", text: $user)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.bottom, 20)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                            .foregroundColor(.white)
                            .padding(.bottom,20)
                    }
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    
                    Button("Sign up") {
                        if (!user.isEmpty && !password.isEmpty) {
                            register()
                            newUser.toggle()
                            errorMessage = nil
                        }else {
                            
                            errorMessage = "Invalid Entry"
                        }
                        
                    }.foregroundColor(.white)
                        .frame(width: 100, height: 50)
                        .bold()
                        .background(.blue)
                        .cornerRadius(15.0)
                        .opacity(0.7)
                        //.offset(x:0,y:10)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Already Have an Account?")
                            .padding(.top, 80)
                            .frame(width: 200, height: 50)
                            //.padding(.bottom, -20)

                        
                    }
                }
                
                
            }.navigationTitle("To Do List:")
                //.padding(.bottom, 20)
            
            
            .fullScreenCover(isPresented: $newUser) {
                ListUIView()
                    
            }
            
            
            
        }
        
        
    }

    func register() {
        Auth.auth().createUser(withEmail: user, password: password) { result, error in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            
        }
    }
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
