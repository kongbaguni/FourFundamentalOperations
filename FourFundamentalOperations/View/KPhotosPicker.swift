//
//  PhotoPicker.swift
//  PixelArtMaker (iOS)
//
//  Created by 서창열 on 2022/04/15.
//

import SwiftUI
import PhotosUI
import AlamofireImage
import SDWebImageSwiftUI

struct KPhotosPicker : View {
    let url:URL?
    let placeHolder : SwiftUI.Image
    @Binding var selectedImage:SwiftUI.Image?
    @State var isLoading = false
    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    @State var isAlert:Bool = false
    @State var photoPickerItem:PhotosPickerItem? = nil
    
    var placeHolderView : some View {
        placeHolder
            .resizable()
            .scaledToFit()
            .foregroundStyle(.symbol1, .symbol2, .symbol3)
            .shadow( color: Color.secondary,radius: 3,x:8,y:8)
            .padding(20)
            .scaledToFit()
            .cornerRadius(20)
            .overlay{
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.buttonPrimaryBorder,lineWidth: 3.0)
            }
    }
    
    var body: some View {
        Group {
            PhotosPicker(
                selection: $photoPickerItem,
                matching: .images, 
                preferredItemEncoding: .automatic,
                photoLibrary: .shared()                
            ) {
                ZStack {
                    if isLoading {
                        ProgressView()
                            .padding(20)
                            .zIndex(10)
                    }
                    Group {
                        if let img = selectedImage {
                            img
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.symbol1, .symbol2, .symbol3)
                                .scaledToFit()
                                .cornerRadius(20)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.buttonPrimaryBorder,lineWidth: 3.0)
                                }
                        }
                        else if let url = url {
                            WebImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(20)
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.buttonPrimaryBorder,lineWidth: 3.0)
                                    }
                                
                            } placeholder: {
                                placeHolderView.opacity(0.4)
                            }
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                        }
                        else  {
                            placeHolderView
                        }
                    }
                    .opacity(isLoading ? 0.3 : 1.0)
                    .blur(radius: isLoading ? 5.0 : 0.0)
                }
                
            }
            if isLoading {
                Text("now loading image")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            else if(photoPickerItem != nil) {
                Button {
                    selectedImage = nil
                    photoPickerItem = nil
                } label: {
                    RoundedBorderImageLabelView(image: .init(systemName: "trash"), title: .init("delete select image"), style: .primary)
                }
            }
        }
        .alert(isPresented: $isAlert, content: {
            .init(title: .init("alert"), message: .init(error!.localizedDescription))
        })
        .onChange(of: photoPickerItem) { value in
            isLoading = value != nil
            if let item = photoPickerItem {
                Task {
                    if let image = try! await item.loadTransferable(type: Image.self)?.asUIImage().resize(.init(width: 600, height: 600)) {
                        isLoading = false
                        
                        selectedImage = Image(uiImage: image)
                    }
                }
            }
        }
      
    }
    
}

#Preview {
    KPhotosPicker(
        url:.init(string: "data:image/jpeg;base64,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"),
        placeHolder: .init(systemName: "person"),
        selectedImage: .constant(nil)
    )
}
