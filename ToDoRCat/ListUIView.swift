//
//  ListUIView.swift
//  ToDoRCat
//
//  Created by Akshayan on 2025-03-20.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ListUIView: View {
    @State private var tasks: [String] = []
    @State private var booleans: [Bool] = []
   @State private var newTask: String = ""
   @State private var selectedTask: String? = nil
   @State private var showMenu: Bool = false
    @State private var score: Int = 0
    @State var vary: Bool = false
    
    let db = Firestore.firestore()
    
    var body: some View {
        ZStack {
            VStack {
                Text("To-Do List")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Enter a task", text: $newTask)
                    //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 300, height: 40)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                    .foregroundColor(.gray)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                
                Button("Add Task") {
                    if (tasks.count < 5 && !newTask.isEmpty) || (isSubscribed2 == 1 && !newTask.isEmpty)  {
                        tasks.append(newTask)
                        booleans.append(false)
                        newTask = ""
                        saveTasksToFirestore()
                        
                        
                    }
                    if tasks.count >= 5 && isSubscribed2 == 0 {
                        vary.toggle()
                    }
                    
                }
                .disabled(newTask.isEmpty)
                .fullScreenCover(isPresented: $vary) {
                    PaywallView(vary: $vary)
                }
                
                
                List {
                    ForEach(tasks.indices, id: \.self) { index in
                        HStack {
                            Button {
                                booleans[index].toggle()
                                saveTasksToFirestore()
                            } label: {
                                Image(systemName: booleans[index] ? "checkmark.circle.fill" : "circle")
                            }
                            
                            Text(tasks[index])
                        }
                    }.onDelete { indexSet in
                        if let index = indexSet.first {
                            deleteTasks(index)
                        }
                        tasks.remove(atOffsets: indexSet)
                        saveTasksToFirestore()
                        loadTasksFromFirestore()
                    }
                }
            }
            .padding()
            
        }.onAppear {
               if Auth.auth().currentUser != nil {
                   print("load complete")
                   loadTasksFromFirestore()
               } else {
                   print("not logged in")
               }
           }
   }
    func deleteTasks(_ idx:Int) {
        guard let user = Auth.auth().currentUser else { return }
        
        let userTasksRef = db.collection("users").document(user.uid).collection("tasks")

        for (index, _) in tasks.enumerated() {
            let taskDocument = userTasksRef.document("\(index)")
            if idx==index {
                taskDocument.delete()
            }
        }
    }
    
    func saveTasksToFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        
        let userTasksRef = db.collection("users").document(user.uid).collection("tasks")

        for (index, task) in tasks.enumerated() {
            let taskDocument = userTasksRef.document("\(index)") 
            
            taskDocument.setData([
                "task": task,
                "completed": booleans[index]
            ]) { error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                } else {
                    print("task saved: \(task)")
                }
            }
        }
    }
    
    func loadTasksFromFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        
        let userTasksRef = db.collection("users").document(user.uid).collection("tasks")

        userTasksRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("no tasks found")
                return
            }
            
            self.tasks = []
            self.booleans = []
            
            for doc in documents {
                if let task = doc.data()["task"] as? String,
                   let completed = doc.data()["completed"] as? Bool {
                    self.tasks.append(task)
                    self.booleans.append(completed)
                }
            }
            
            print("loadded tasks: \(self.tasks)")
        }
    }
}



struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
       ContentView()
   }
}

