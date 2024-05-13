//
//  ContentView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/6/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.isPreview) var isPreview
    @State var account:AccountModel? = nil
    @State var isLogin:Bool = false
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    AccountMenuView(isLogin: isLogin)
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
                Section {
                    StageListView()
                }
            }
            .padding()
            .navigationTitle(.init("Home"))
            .listStyle(.insetGrouped)
            
            
        }
        .onAppear {
            isLogin = AuthManager.shared.auth.currentUser != nil
            guard isLogin else {
                return
            }
            if !isPreview {
                StageModel.sync { error in
                    
                }
                account = AuthManager.shared.accountModel
            }
            else {
                account = .init(userId: "kongbaguni", accountRegDt: Date(), accountLastSigninDt: Date(), email: "kong@gmail.com", phoneNumber: "010-1234-1234", photoURL: URL(string:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQJs3r3gRot-57vHrAZfYX8uKRbw8CkyEQa-NdFJ1EnzF5AKtTr280BWejnw&s"), isAnonymous: false)
            }

        }
        .onReceive(NotificationCenter.default.publisher(for: .authDidSucessed), perform: { _ in
            account = AuthManager.shared.accountModel
            isLogin = AuthManager.shared.auth.currentUser != nil
            StageModel.sync { error in
                
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: .signoutDidSucessed), perform: { _ in
            account = nil
            isLogin = AuthManager.shared.auth.currentUser != nil

        })
            
    }
}

#Preview {
    ContentView()
}
