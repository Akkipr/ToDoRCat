//
//  ToDoRCatApp.swift
//  ToDoRCat
//
//  Created by Akshayan on 2025-03-20.
//


import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

var isSubscribed2: Int = 0
@main
struct ToDoRCatApp: App {
    @StateObject var storage = Storage()
    
    init() {
        FirebaseApp.configure()
    }
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storage)
        }
        .modelContainer(sharedModelContainer)
    }
}


