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
    @Binding var data:Data?
    @State var selectedImage:SwiftUI.Image? = nil
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
                photoLibrary: PHPhotoLibrary.shared()
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
                
            }.frame(maxHeight: 200)
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
                    if let data = try! await item.loadTransferable(type: Data.self),
                        let image = UIImage(data: data)?.af.imageAspectScaled(toFill: .init(width: 300, height: 300), scale: 1) {
                        
                        isLoading = false
                        selectedImage = Image(uiImage: image)
                        self.data = image.jpegData(compressionQuality: 0.7)
                    }
                }
            }
        }
      
    }
    
}

#Preview {
    List {
        KPhotosPicker(
            url:.init(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBxCX8umDOLWV1cXINz_fzqWaYqFuoIG_efg&usqp=CAU"),
            placeHolder: .init(systemName: "person"),
            data: .constant(nil)
        )
    }
}
