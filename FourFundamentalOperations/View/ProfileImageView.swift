//
//  ProfileImageView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/26/24.
//

import SwiftUI
import RealmSwift
import CachedAsyncImage

struct ProfileImageView : View {
    let account:AccountModel
    @ObservedRealmObject var profile:ProfileModel
    @State var profileImageURL:URL? = nil

    init(account:AccountModel) {
        self.account = account
        self.profile = account.myProfile ?? ProfileModel()
    }
    
    var body : some View {
        ZStack {
            if let url = profileImageURL {
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
            else {
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundStyle(.symbol1, .symbol2, .symbol3)
                    .padding(20)
                    .scaledToFit()
                    .cornerRadius(20)
                    .shadow( color: Color.secondary,radius: 3,x:8,y:8)
                    .overlay{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.buttonPrimaryBorder,lineWidth: 3.0)
                    }
            }
        }
        .onAppear {
            if self.profileImageURL == nil {
                self.profileImageURL = account.photoURL
            }
            account.getMyProfileImageURL { url, error in
                DispatchQueue.main.async {
                    self.profileImageURL = url
                }
            }

        }
    }
}

#Preview {
    ProfileImageView( account: .init(userId: "kongbaguni", accountRegDt: Date(), accountLastSigninDt: Date(), email: "kongbaguni@gmail.com", phoneNumber: "010-1234-1234", photoURL: URL(string: "https://mblogthumb-phinf.pstatic.net/MjAyMTAyMDRfNjIg/MDAxNjEyNDA4OTk5NDQ4.6UGs399-0EXjIUwwWsYg7o66lDb-MPOVQ-zNDy1Wnnkg.m-WZz0IKKnc5OO2mjY5dOD-0VsfpXg7WVGgds6fKwnIg.JPEG.sunny_side_up12/1612312679152%EF%BC%8D2.jpg?type=w800"), isAnonymous: false))
}
