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
    
    init(profile:ProfileModel) {
        if AuthManager.shared.userId == profile.id {
            account = AuthManager.shared.accountModel
        }
        self.profile = profile
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
        
        ProfileView(profile: ProfileModel.Test)
        
    }
}
