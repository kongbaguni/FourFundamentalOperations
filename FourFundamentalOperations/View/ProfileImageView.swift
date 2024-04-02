//
//  ProfileImageView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/26/24.
//

import SwiftUI
import RealmSwift
import SDWebImageSwiftUI

struct ProfileImageView : View {
    let account:AccountModel
    @ObservedRealmObject var profile:ProfileModel
    @State var profileImageURL:URL? = nil

    init(account:AccountModel) {
        self.account = account
        self.profile = account.myProfile ?? ProfileModel()
    }
    var placeholder : some View {
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
    
    var body : some View {
            Group {
                if let url = profileImageURL {
                    WebImage(url: url) {
                        image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .overlay{
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.buttonPrimaryBorder,lineWidth: 3.0)
                            }
                        
                    } placeholder: {
                        placeholder
                    }
                    .indicator(.progress)
                    .transition(.fade(duration: 0.5))
                }
                else {
                    placeholder
                }
        }
        .frame(maxWidth: 300)
        .onAppear {
//            if self.profileImageURL == nil {
//                self.profileImageURL = account.photoURL
//            }
            account.getMyProfileImageURL { url, error in
                DispatchQueue.main.async {
                    self.profileImageURL = url
                }
            }

        }
        .onReceive(NotificationCenter.default.publisher(for: .profilePhotoDidUpdated), perform: { noti in
            if let info = noti.userInfo,
               let url = info["url"] as? String,
               let id = info["id"] as? String {
                if account.userId == id {
                    profileImageURL = URL(string: url)
                }
            }
        })
        
    }
}

#Preview {
    ProfileImageView( account: .init(userId: "kongbaguni", accountRegDt: Date(), accountLastSigninDt: Date(), email: "kongbaguni@gmail.com", phoneNumber: "010-1234-1234", photoURL: URL(string: "https://pbs.twimg.com/media/EiQTMoDXsAAIkD2?format=png&name=360x360"), isAnonymous: false))
}
