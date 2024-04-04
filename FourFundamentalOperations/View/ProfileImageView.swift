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
    @Environment(\.isPreview) var isPreview
    @ObservedRealmObject var profile:ProfileModel
    @State var profileImageURL:URL? = nil

    init(profile:ProfileModel) {
        self.profile = profile
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
            if isPreview {
                self.profileImageURL = URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQJs3r3gRot-57vHrAZfYX8uKRbw8CkyEQa-NdFJ1EnzF5AKtTr280BWejnw&s")
            } else {
                profile.getProfileImageUrl { url, error in
                    DispatchQueue.main.async {
                        self.profileImageURL = url
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .profilePhotoDidUpdated), perform: { noti in
            if let info = noti.userInfo,
               let url = info["url"] as? String,
               let id = info["id"] as? String {
                if profile.id == id {
                    profileImageURL = URL(string: url)
                }
            }
        })
        
    }
}

#Preview {
    ProfileImageView(profile: ProfileModel.Test)
}
