//
//  ProfileEditView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/25/24.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

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
    
    
    var body: some View {
        List {
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
            if let model = ProfileModel.myProfile {
                nickname = model.nickname
                aboutMe = model.aboutMe
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileEditView()
    }
}
