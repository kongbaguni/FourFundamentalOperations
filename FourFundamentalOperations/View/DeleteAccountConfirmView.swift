//
//  DeleteAccountConfirmView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/15/24.
//

import SwiftUI

struct DeleteAccountConfirmView: View {
    @State var account:AccountModel? = AuthManager.shared.accountModel
    var body: some View {
        VStack {
            
        }
    }
}

#Preview {
    DeleteAccountConfirmView(account: .init(userId: "kongbaguni.net", accountRegDt: Date(), accountLastSigninDt: Date(), email: "kongbaguni@gmail.com", phoneNumber: "010-1234-1234", photoURL: nil, isAnonymous: false))
    
}
