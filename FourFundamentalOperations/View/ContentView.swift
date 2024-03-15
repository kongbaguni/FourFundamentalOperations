//
//  ContentView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/6/24.
//

import SwiftUI

struct ContentView: View {
    @State var account:AccountModel? = nil
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    AccountMenuView()
                } label: {
                    if let account = account {
                        Text(account.email ?? account.userId)
                    }
                    else {
                        Text("Account")
                    }
                }
            }
            .navigationTitle(.init("Home"))
            .listStyle(.insetGrouped)
        }
        .onAppear {
            account = AuthManager.shared.accountModel
        }
        .onReceive(NotificationCenter.default.publisher(for: .authDidSucessed), perform: { _ in
            account = AuthManager.shared.accountModel
        })
        .onReceive(NotificationCenter.default.publisher(for: .signoutDidSucessed), perform: { _ in
            account = nil 
        })
            
    }
}

#Preview {
    ContentView()
}
