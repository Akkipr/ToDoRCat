//
//  ListUIView.swift
//  ToDoRCat
//
//  Created by Akshayan on 2025-03-20.
//
import SwiftUI

struct ListUIView: View {
    @State private var tasks: [String] = []
   @State private var newTask: String = ""
   @State private var selectedTask: String? = nil
   @State private var showMenu: Bool = false
   
   var body: some View {
       ZStack {
           VStack {
               Text("To-Do List")
                   .font(.largeTitle)
                   .padding()
               
               TextField("Enter a task", text: $newTask)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   .padding()
               
               Button("Add Task") {
                   if tasks.count < 5, !newTask.isEmpty {
                       tasks.append(newTask)
                       newTask = ""
                   }
               }
               .disabled(tasks.count >= 5 || newTask.isEmpty)
               .padding()
               
               List {
                   ForEach(tasks, id: \..self) { task in
                       Text(task)
                           .onTapGesture {
                               selectedTask = task
                               withAnimation {
                                   showMenu = true
                               }
                           }
                   }
                   .onDelete { indexSet in
                       tasks.remove(atOffsets: indexSet)
                   }
               }
           }
           .padding()
           
           if showMenu {
               VStack {
                   Spacer()
                   VStack {
                       Text("Options for \(selectedTask ?? "")")
                           .font(.headline)
                           .padding()
                       
                       Button("Close") {
                           withAnimation {
                               showMenu = false
                           }
                       }
                       .padding()
                       
                   }
                   .frame(maxWidth: .infinity)
                   .frame(height: 200)
                   .background(Color.white)
                   .cornerRadius(20)
                   .shadow(radius: 10)
                   .transition(.move(edge: .bottom))
               }
               .edgesIgnoringSafeArea(.bottom)
           }
       }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
       ContentView()
   }
}
