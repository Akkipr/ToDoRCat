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
    var body: some View {
        NavigationView{
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 40, height: 10))
                    .frame(width: 400,height: 100)
                    .foregroundColor(.gray)
                    .opacity(0.3)
                    .offset(x:0.0,y:-300.0)
                RoundedRectangle(cornerSize: CGSize(width: 40, height: 10))
                    .frame(width: 400,height: 400)
                    .foregroundColor(.blue)
                    .opacity(0.3)
                    .offset(x:0.0,y:-0.0)
                RoundedRectangle(cornerSize: CGSize(width: 40, height: 10))
                    .frame(width: 400,height: 100)
                    .foregroundColor(.gray)
                    .opacity(0.3)
                    .padding(.top)
                    .offset(x:0.0,y:+300.0)
                VStack (spacing: 15){
                    
                    TextField("Email", text: $user)
                        .padding(.leading,2)
                        .frame(width:370, height:40)
                        .border(.green)
                        .cornerRadius(6.0)
                        .font(.system(size: 20.0))
                        .padding(.leading,1)
                        .padding(.bottom, 45)
                        .offset(x:0, y:-35)
                    SecureField("Password", text: $password)
                        .padding(.leading,2)
                        .frame(width:370, height:40)
                        .border(.green)
                        .cornerRadius(6.0)
                        .font(.system(size: 20.0))
                        .padding(.leading,1)
                        .offset(x:0, y:-65)
                }
                
                NavigationLink(destination: LoginView()) {
                        Text("Already Have an Account?")
                        .frame(width: 200, height: 50)
                        .padding(.top, 470)
                                                
                }
                
                
                Button("Sign up") {
                    register()
                    newUser.toggle()
                        
                }.foregroundColor(.white)
                    .frame(width: 100, height: 50)
                    .bold()
                    .background(.blue)
                    .cornerRadius(15.0)
                    .opacity(0.7)
                    .offset(x:0,y:310)
                
                
                
            }.navigationTitle("To Do List:")
                .padding(.bottom,120)
            
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
