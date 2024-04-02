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
                    AccountMenuView(isLogin: AuthManager.shared.auth.currentUser != nil)
                } label: {

                    if let account = account {
                        RoundedBorderImageLabelView(
                            image: .init(systemName: "person.fill"),
                            title: .init(account.email ?? account.userId),
                            style: .primary)

                    }
                    else {
                        RoundedBorderImageLabelView(
                            image: .init(systemName: "person.fill"),
                            title: .init("account"),
                            style: .primary)

                    }
                }
                
                
                NavigationLink {
                    MakeStageView()
                } label : {
                    RoundedBorderImageLabelView(image: .init(systemName:"doc.badge.plus"), title: .init("create new game"), style: .primary)
                }
                
                
            }
            .padding()
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
