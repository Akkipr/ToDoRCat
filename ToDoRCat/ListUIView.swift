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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add Task") {
                    if tasks.count < 5, !newTask.isEmpty {
                        tasks.append(newTask)
                        booleans.append(false) // Append a false value for each new task
                        newTask = ""
                        saveTasksToFirestore()
                        
                        
                    }
                    if tasks.count >= 5 {
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
                                // Toggle the boolean value at the corresponding index in booleans
                                booleans[index].toggle()
                                saveTasksToFirestore()
                            } label: {
                                Image(systemName: booleans[index] ? "checkmark.circle.fill" : "circle")
                            }
                            
                            Text(tasks[index])
                        }
                    }.onDelete { indexSet in
                        if let index = indexSet.first {  // Get the first (or only) index
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
                   print("🔍 Loading tasks from Firestore...")
                   loadTasksFromFirestore()
               } else {
                   print("❌ User is not logged in!")
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
                    print("❌ Error saving task: \(error.localizedDescription)")
                } else {
                    print("✅ Task saved successfully: \(task)")
                }
            }
        }
    }
    
    func loadTasksFromFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        
        let userTasksRef = db.collection("users").document(user.uid).collection("tasks")

        userTasksRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("❌ Error loading tasks: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("⚠️ No tasks found")
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
            
            print("✅ Loaded tasks: \(self.tasks)")
        }
    }
}



struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
       ContentView()
   }
}

