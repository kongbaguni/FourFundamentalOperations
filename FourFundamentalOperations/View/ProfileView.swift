//
//  MenuView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/6/24.
//

import Foundation
import SwiftUI
/**
 메뉴 표시하는 컴포넌트
 */
struct ProfileView : View {
    @State var isLogin = false
    @State var isAnonymousLogin = false
    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    @State var isAlert:Bool = false
    
    var loginView : some View {
        Group {
            Text(AuthManager.shared.auth.currentUser?.uid ?? "test")
            
            ButtonView(image: .init(systemName: "rectangle.portrait.and.arrow.right"), title: .init("Sign Out"), style: .secondary) {
                if AuthManager.shared.signout() == nil {
                    isLogin = false
                }
            }
            if !isAnonymousLogin {
                ButtonView(image: .init(systemName: "trash.fill"),
                           title: .init("Delete Account"),
                           style: .secondary) {
                    AuthManager.shared.leave { error in
                        self.error = error
                        if error == nil {
                            self.isLogin = false
                        }
                    }
                }
            }
        }
    }
    
    var notLoginView : some View {
        Group {
            ButtonView(
                image: .init(systemName: "apple.logo"),
                title: .init("Sign in with Apple"),
                style: .primary) {
                    AuthManager.shared.startSignInWithAppleFlow { error in
                        if(error == nil) {
                            isLogin = true
                            isAnonymousLogin = false
                        }
                        self.error = error
                    }
                }
            
            ButtonView(
                image: .init("GoogleLogo"),
                title: .init("Sign in with Google"),
                style: .primary) {
                    AuthManager.shared.startSignInWithGoogleId { error in
                        if(error == nil) {
                            isLogin = true
                            isAnonymousLogin = false
                        }
                        self.error = error
                    }
                }
            
            ButtonView(
                image: .init(systemName: "person.fill.questionmark"),
                title: .init("Sign in with anonymous"),
                style: .secondary, onclick: {
                    AuthManager.shared.startSignInAnonymously { error in
                        if(error == nil) {
                            isLogin = true
                            isAnonymousLogin = true
                        }
                        self.error = error
                    }
                })
        }
    }
    
    var upgradeButtons : some View {
        Group {
            ButtonView(
                image: .init(systemName: "apple.logo"),
                title: .init("Continue with Apple"),
                style: .primary) {
                    AuthManager.shared.upgradeAnonymousWithAppleId { error in
                        isAnonymousLogin = !(error == nil)
                        self.error = error
                    }
                }
            ButtonView(
                image: .init("GoogleLogo"),
                title: .init("Continue with Google"),
                style: .primary) {
                    AuthManager.shared.upgradeAnonymousWithGoogleId { error in
                        isAnonymousLogin = !(error == nil)
                        self.error = error
                    }
                }
        }
    }
    
    var body: some View {
        ScrollView {
            if isLogin {
                loginView
                if isAnonymousLogin {
                    upgradeButtons
                }
            } else {
                notLoginView
            }
        }
        .navigationTitle(.init("Profile"))
        .padding()
        .onAppear {
            isLogin = AuthManager.shared.auth.currentUser != nil
            isAnonymousLogin = AuthManager.shared.auth.currentUser?.isAnonymous ?? false
        }
        .alert(isPresented: $isAlert, content: {
            .init(title: .init("alert"), message: .init(error!.localizedDescription))
        })
    }
}

#Preview {
    ProfileView()
}
