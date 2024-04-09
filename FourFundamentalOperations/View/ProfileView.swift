//
//  ProfileView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/15/24.
//

import SwiftUI
import RealmSwift


struct ProfileView: View {
    enum Style {
        case large
        case small
    }
    @Environment(\.isPreview) var isPreview
    @State var account:AccountModel? = nil
    @ObservedRealmObject var profile:ProfileModel
    let style:Style
    init(profile:ProfileModel, style:Style = .large) {
        if AuthManager.shared.userId == profile.id {
            account = AuthManager.shared.accountModel
        }
        self.profile = profile
        self.style = style
    }

    var large: some View {
        VStack(alignment: .leading) {
            ProfileImageView(profile: profile)
                
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
    
    var small: some View {
        HStack {
            ProfileImageView(profile: profile)
                .frame(width:50,height: 50)
            VStack(alignment:.leading) {
                Text(profile.nickname)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.primary)
                Text(profile.aboutMe)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }.padding()
    }
    var body: some View {
        Group {
            switch style {
            case .large:
                large
            case .small:
                small
            }
        }
        
    }
       
}

#Preview {
    NavigationStack {
        
        ProfileView(profile: ProfileModel.Test, style: .small)
        
    }
}
