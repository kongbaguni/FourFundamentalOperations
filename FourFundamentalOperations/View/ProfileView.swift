//
//  ProfileView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/15/24.
//

import SwiftUI
import RealmSwift


struct ProfileView: View {
    @Environment(\.isPreview) var isPreview
    
    @State var account:AccountModel? = nil
    @ObservedRealmObject var profile:ProfileModel
    
    init(id:String) {
        if AuthManager.shared.userId == id {
            account = AuthManager.shared.accountModel
        }
        #if DEBUG
            profile = ProfileModel.Test
        #else
            profile = Realm.shared.object(ofType: ProfileModel.self, forPrimaryKey: id) ?? ProfileModel()
        #endif
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let account = account {
                ProfileImageView(profile: account.myProfile ?? ProfileModel())
            }
                
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
                
            if let account = account {
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
        }
        .padding()       
        
    }
       
}

#Preview {
    NavigationStack {
//        ProfileView(
//            account: .init(userId: "kongbaguni", accountRegDt: Date(), accountLastSigninDt: Date(), email: "kongbaguni@gmail.com", phoneNumber: "010-1234-1234", photoURL: URL(string: "https://mblogthumb-phinf.pstatic.net/MjAyMTAyMDRfNjIg/MDAxNjEyNDA4OTk5NDQ4.6UGs399-0EXjIUwwWsYg7o66lDb-MPOVQ-zNDy1Wnnkg.m-WZz0IKKnc5OO2mjY5dOD-0VsfpXg7WVGgds6fKwnIg.JPEG.sunny_side_up12/1612312679152%EF%BC%8D2.jpg?type=w800"), isAnonymous: false)
//        )
        
        ProfileView(id: "kongbaguni")
        
    }
}
