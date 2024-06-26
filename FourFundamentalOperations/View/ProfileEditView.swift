//
//  ProfileEditView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/25/24.
//

import SwiftUI
import RealmSwift

struct ProfileEditView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var accountId:String? {
        AuthManager.shared.userId
    }
    
    @State var selectImageData:Data? = nil
    @State var nickname:String = ""
    @State var aboutMe:String = ""
    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    @State var isAlert:Bool = false
    
    @State var photoURL:URL? = nil
    
    var body: some View {
        List {
            KPhotosPicker(url: photoURL, placeHolder: .init(systemName: "person.fill"), data: $selectImageData)
            

            HStack {
                Text("nickname")
                KTextField(title: .init("nickname"), text: $nickname)
            }
            
            HStack {
                Text("aboutMe")
                KTextEditor(text: $aboutMe)
            }
                    
        }
        .navigationTitle("Profile Edit")
        .toolbar {
            Button {
                ProfileModel.make(nickname: nickname, aboutMe: aboutMe) { error in
                    if error == nil {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    if let data = selectImageData, let id = accountId {
                        FirebaseFirestorageHelper.shared.uploadData(data: data, contentType: .jpeg, uploadPath: "profile", id: id) { error in
                            self.error = error
                        }
                    }
                }
                
            } label: {
                VStack {
                    Image(systemName: "cloud")
                    Text("save")
                }
            }
        }
        .alert(isPresented: $isAlert, content: {
            Alert(title: .init("alert"), message: .init(error!.localizedDescription))
        })
        .onAppear {
            guard let id = accountId else {
                return
            }
            ProfileModel.getProfile(id: id) { error in
                if let model = Realm.shared.object(ofType: ProfileModel.self, forPrimaryKey: id) {
                    nickname = model.nickname
                    aboutMe = model.aboutMe
                    print("----- \(id) \(nickname) \(aboutMe) \(model)")
                    model.getProfileImageUrl(complete: { url, error in
                        photoURL = url
                    })
                }
            }
        
        }
    }
}

#Preview {
    NavigationStack {
        ProfileEditView()
    }
}
