//
//  MenuView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/6/24.
//

import Foundation
import SwiftUI
/**
 계정 관련 메뉴 표시하는 컴포넌트
 */
struct AccountMenuView : View {
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
            if let id = AuthManager.shared.userId {
                ProfileView(id: id)
            }
            /** 로그아웃 버튼 */
            ButtonView(image: .init(systemName: "rectangle.portrait.and.arrow.right"), title: .init("Sign Out"), style: .secondary) {
                if isAnonymousLogin {
                    error = CustomError.anonymousSignOut
                    return
                }
                error = AuthManager.shared.signout()
            }
            if !isAnonymousLogin {
                NavigationLink {
                    DeleteAccountConfirmView()
                } label: {
                    RoundedBorderImageLabelView(image: .init(systemName: "trash"), title: .init("Delete Account"), style: .primary)
                }

            }
        }
    }
    
    var notLoginView : some View {
        Group {
            /** Apple 로 로그인 */
            ButtonView(
                image: .init(systemName: "apple.logo"),
                title: .init("Sign in with Apple"),
                style: .primary) {
                    AuthManager.shared.startSignInWithAppleFlow { error in
                        self.error = error
                    }
                }
            /** 구글로 로그인*/
            ButtonView(
                image: .init("GoogleLogo"),
                title: .init("Sign in with Google"),
                style: .primary) {
                    AuthManager.shared.startSignInWithGoogleId { error in
                        self.error = error
                    }
                }
            /** 익명 로그인 */
            ButtonView(
                image: .init(systemName: "person.fill.questionmark"),
                title: .init("Sign in with anonymous"),
                style: .secondary, onclick: {
                    AuthManager.shared.startSignInAnonymously { error in
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
                        self.error = error
                    }
                }
            ButtonView(
                image: .init("GoogleLogo"),
                title: .init("Continue with Google"),
                style: .primary) {
                    AuthManager.shared.upgradeAnonymousWithGoogleId { error in
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
        .toolbar {
            if isLogin {
                NavigationLink(destination: ProfileEditView(account: AuthManager.shared.accountModel!)) {
                    VStack {
                        Image(systemName: "square.and.pencil")
                        Text("edit profile")
                    }
                }
            }
        }
        .navigationTitle(.init("Account"))
        .padding()
        .onAppear {
            update()
        }
        .alert(isPresented: $isAlert, content: {
            switch error as? CustomError {
            case .anonymousSignOut:
                return .init(
                    title: .init("alert"),
                    message: .init(error!.localizedDescription),
                    primaryButton: .cancel(),
                    secondaryButton: .default(.init("confirm"), action: {
                        error = AuthManager.shared.signout()
                        
                    }))
            default:
                return
                    .init(title: .init("alert"), message: .init(error!.localizedDescription))
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: .authDidSucessed), perform: { _ in
            update()
        })
    }
        
    
    func update() {
        DispatchQueue.main.async {
            isLogin = AuthManager.shared.auth.currentUser != nil
            isAnonymousLogin = AuthManager.shared.auth.currentUser?.isAnonymous ?? false
        }
    }
}

#Preview {
    AccountMenuView()
}
