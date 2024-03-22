//
//  DeleteAccountConfirmView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/15/24.
//

import SwiftUI
struct AniImageView : View {
    let image:Image
    @Binding var value:Int
    var body : some View {
        if #available(iOS 17.0, *) {
            image
                .resizable()
                .symbolEffect(.bounce, value: value)
        }
        else {
            image
        }
    }
}

struct DeleteAccountConfirmView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var account:AccountModel? = AuthManager.shared.accountModel
    @State var count = 0;
    @State var isMatch = 0;
    @State var confirmText = "";
    
    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    @State var isAlert = false
    
    var id:String {
        account?.email ?? account?.userId ?? ""
    }
    
    var body: some View {
        ScrollView {
            Group {
                HStack {
                    Group {
                        AniImageView(image: .init(systemName: "person.text.rectangle"), value: $isMatch)
                        AniImageView(image: .init(systemName: "arrow.forward"), value: $count)
                            .frame(width: 50)
                        AniImageView(image: .init(systemName: "trash"), value: $isMatch)
                    }
                    .scaledToFit()
                    .foregroundStyle(.symbol1, .symbol2, .symbol3)
                }
                .padding(.bottom, 20)
                
                Text(String(format: NSLocalizedString("delete account desc", comment: "계정 삭제"), id))
                    .padding(.bottom, 30)
                KTextField(title: .init(id), text: $confirmText)
                    .onChange(of: confirmText) { text in
                        count += 1;
                        let test = text.trimmingCharacters(in: .whitespacesAndNewlines)
                        isMatch = id == test ? 1 : 0
                    }
                    .padding(.bottom, 10)
                          
                if(isMatch == 1) {
                    ButtonView(image: .init(systemName: "return"), title: .init("delete"), style: .primary) {
                        AuthManager.shared.leave { error in
                            self.error = error
                            if error == nil {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("delete account")
        .alert(isPresented: $isAlert, content: {
            .init(title: .init("alert"), message: .init(error!.localizedDescription))
        })
        .onAppear {
            #if DEBUG
            confirmText = id
            #endif
        }
    }
}

#Preview {
    NavigationStack {
        DeleteAccountConfirmView(account: .init(userId: "kongbaguni.net", accountRegDt: Date(), accountLastSigninDt: Date(), email: "kongbaguni@gmail.com", phoneNumber: "010-1234-1234", photoURL: nil, isAnonymous: false))
            .navigationTitle("delete account")
    }
    
}
