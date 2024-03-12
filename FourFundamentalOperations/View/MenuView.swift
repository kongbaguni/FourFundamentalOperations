//
//  MenuView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/6/24.
//

import Foundation
import SwiftUI

struct MenuView : View {
    @State var isLogin = false
    
    var body: some View {
        VStack {
            if isLogin {
                Text(AuthManager.shared.auth.currentUser?.uid ?? "")
                ButtonView(image: .init(systemName: "rectangle.portrait.and.arrow.right"), title: .init("Sign Out"), style: .secondary) {
                    if AuthManager.shared.signout() == nil {
                        isLogin = false
                    }
                }
            } else {
                ButtonView(
                    image: .init(systemName: "apple.logo"),
                    title: .init("Sign in with Apple"),
                    style: .primary) {
                        AuthManager.shared.startSignInWithAppleFlow { error in
                            isLogin = error == nil
                        }
                    }
                ButtonView(
                    image: .init("GoogleLogo"),
                    title: .init("Sign in with Google"),
                    style: .primary) {
                        AuthManager.shared.startSignInWithGoogleId { error in
                            isLogin = error == nil
                        }
                    }
                
                ButtonView(
                    image: .init(systemName: "person.fill.questionmark"),
                    title: .init("Sign in with anonymous"),
                    style: .secondary, onclick: {
                        AuthManager.shared.startSignInAnonymously { error in
                            isLogin = error == nil
                        }
                    })
            }
            
        }
        .padding()
        .onAppear {
            isLogin = AuthManager.shared.auth.currentUser != nil
        }
    }
}

#Preview {
    MenuView()
}
