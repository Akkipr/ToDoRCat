//
//  PaywallView.swift
//  ToDoRCat
//
//  Created by Akshayan on 2025-03-22.
//

import SwiftUI

struct PaywallView: View {
    @State var isSubscribed = false
    @Binding var vary: Bool

    
    var body: some View {
        VStack(spacing: 20) {
            Text("🚀 You have reached your limit!")
                .font(.largeTitle)
                .bold()
            
            Text("Get premium features for free in this test mode.")
                .padding()
            
            Button("Subscribe") {
                isSubscribed = true
                isSubscribed2 = 1
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .alert("Thanks for Upgrading!", isPresented: $isSubscribed) {
                Button("OK", role: .cancel) {}
            }
            
            Button("Cancel") {
                vary.toggle()
            }
            
            .fullScreenCover(isPresented: $isSubscribed) {
                ListUIView()
                    
            }
            
            
        }
    }
}
