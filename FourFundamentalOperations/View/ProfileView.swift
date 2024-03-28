//
//  ProfileView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/15/24.
//

import SwiftUI
import RealmSwift


struct ProfileView: View {
    let account:AccountModel
    @ObservedRealmObject var profile:ProfileModel
    init(account:AccountModel) {
        self.account = account
        self.profile = account.myProfile ?? ProfileModel()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ProfileImageView(account: account)
            
            if !profile.nickname.isEmpty {
                HStack {
                    Text("nickname")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(profile.nickname)
                }
            }
            if !profile.aboutMe.isEmpty {
                HStack {
                    Text("aboutMe")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(profile.aboutMe)
                }
            }
            
            HStack {
                Text("ID")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(account.userId)
            }
            if let email = account.email {
                HStack {
                    Text("Email")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(email)
                }
            }
            if let phoneNumber = account.phoneNumber {
                HStack {
                    Text("PhoneNumber")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(phoneNumber)
                }
            }
            if let date = account.accountRegDt {
                HStack {
                    Text("Reg Date")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(date.formatted(.dateTime))
                }
            }
            if let date = account.accountLastSigninDt {
                HStack {
                    Text("Last Sign in Date")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(date.formatted(.dateTime))
                }
            }
        }
        .padding()       
        
    }
       
}

#Preview {
    NavigationStack {
        ProfileView(
            account: .init(userId: "kongbaguni", accountRegDt: Date(), accountLastSigninDt: Date(), email: "kongbaguni@gmail.com", phoneNumber: "010-1234-1234", photoURL: URL(string: "https://mblogthumb-phinf.pstatic.net/MjAyMTAyMDRfNjIg/MDAxNjEyNDA4OTk5NDQ4.6UGs399-0EXjIUwwWsYg7o66lDb-MPOVQ-zNDy1Wnnkg.m-WZz0IKKnc5OO2mjY5dOD-0VsfpXg7WVGgds6fKwnIg.JPEG.sunny_side_up12/1612312679152%EF%BC%8D2.jpg?type=w800"), isAnonymous: false)
        )
        
    }
}
