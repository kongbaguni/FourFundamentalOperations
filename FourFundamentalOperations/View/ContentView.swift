//
//  ContentView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    ProfileView()                        
                } label: {
                    Text("Profile")                    
                }
            }
            .navigationTitle(.init("Home"))
            .listStyle(.insetGrouped)
        }
            
    }
}

#Preview {
    ContentView()
}
