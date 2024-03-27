//
//  ProfileEditView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/25/24.
//

import SwiftUI


struct ProfileEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let account:AccountModel
    @State var selectImage:Image? = nil
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
            KPhotosPicker(url: photoURL, placeHolder: .init(systemName: "person.fill"), selectedImage: $selectImage)
            

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
                    if let image = selectImage {
                        
                        FirebaseFirestorageHelper.shared.uploadImage(image: image, contentType: .jpeg, uploadPath: "profile", id: account.userId) { error in
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
            if let model = account.myProfile {
                nickname = model.nickname
                aboutMe = model.aboutMe
            }
            photoURL = account.photoURL
            account.getMyProfileImageURL { url, error in
                photoURL = url
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileEditView(account:.init(userId: "kongbaguni", accountRegDt: Date(), accountLastSigninDt: Date(), email: "kongbaguni@gmail.com", phoneNumber: "010-1234-1234", photoURL: URL(string: "https://mblogthumb-phinf.pstatic.net/MjAyMTAyMDRfNjIg/MDAxNjEyNDA4OTk5NDQ4.6UGs399-0EXjIUwwWsYg7o66lDb-MPOVQ-zNDy1Wnnkg.m-WZz0IKKnc5OO2mjY5dOD-0VsfpXg7WVGgds6fKwnIg.JPEG.sunny_side_up12/1612312679152%EF%BC%8D2.jpg?type=w800"), isAnonymous: false))
    }
}
