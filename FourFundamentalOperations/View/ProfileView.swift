//
//  ProfileView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/15/24.
//

import SwiftUI
import CachedAsyncImage

struct ProfileView: View {
    let account:AccountModel
    var body: some View {
        VStack {
            if let url = account.photoURL {
                CachedAsyncImage(url: url) {
                    image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .shadow( color: Color.secondary,radius: 3,x:8,y:8)
                        .overlay{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.buttonPrimaryBorder,lineWidth: 3.0)
                        }
                    
                } placeholder: {
                    ProgressView()
                        .padding(20)
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
        }.padding()
    }
}

#Preview {
    ProfileView(
        account: .init(userId: "kongbaguni", accountRegDt: Date(), accountLastSigninDt: Date(), email: "kongbaguni@gmail.com", phoneNumber: "010-1234-1234", photoURL: URL(string: "https://mblogthumb-phinf.pstatic.net/MjAyMTAyMDRfNjIg/MDAxNjEyNDA4OTk5NDQ4.6UGs399-0EXjIUwwWsYg7o66lDb-MPOVQ-zNDy1Wnnkg.m-WZz0IKKnc5OO2mjY5dOD-0VsfpXg7WVGgds6fKwnIg.JPEG.sunny_side_up12/1612312679152%EF%BC%8D2.jpg?type=w800"), isAnonymous: false)
    )
}
