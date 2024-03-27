//
//  FirebaseFirestorageHelper.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/26/24.
//

import Foundation
import FirebaseStorage
import SwiftUI

class FirebaseFirestorageHelper {
    static let shared = FirebaseFirestorageHelper()
    
    enum ContentType:String {
        case png = "image/png"
        case jpeg = "image/jpeg"
    }
    
    fileprivate let storageRef = Storage.storage().reference()
    

    func uploadImage(url:URL, contentType:ContentType, uploadPath:String, id:String, complete:@escaping(_ error:Error?)->Void) {
        guard var data = try? Data(contentsOf: url) else {
            return
        }
        
        switch contentType {
        case .png:
            if let pngdata = UIImage(data: data)?.pngData() {
                data = pngdata
            }
        case .jpeg:
            if let jpedata = UIImage(data: data)?.jpegData(compressionQuality: 0.7) {
                data = jpedata
            }
        }
        uploadData(data: data, contentType: contentType, uploadPath: uploadPath, id: id, complete: complete)
    }
    
    func uploadImage(image:Image, contentType:ContentType, uploadPath:String, id:String, complete:@escaping(_ error:Error?)->Void) {
        let uiimage = image.asUIImage()
        var data:Data? = nil
        switch contentType {
        case .png:
            data = uiimage.pngData()
        case .jpeg:
            data = uiimage.jpegData(compressionQuality: 0.7)
        }
        uploadData(data: data!, contentType: contentType, uploadPath: uploadPath, id: id, complete: complete)
    }
    
    
    func uploadData(data:Data, contentType:ContentType, uploadPath:String, id:String, complete:@escaping(_ error:Error?)->Void) {
        let ref:StorageReference = storageRef.child("\(uploadPath)/\(id)")
        let metadata = StorageMetadata()
        metadata.contentType = contentType.rawValue
        let task = ref.putData(data, metadata: metadata)
        task.observe(.success) { snapshot in
            complete(snapshot.error)
        }
        task.observe(.failure) { snapshot in
            complete(snapshot.error)
        }
    }
    
    
    func getURL(path:String, id:String, complete:@escaping(_ url:URL?, _ error:Error?)->Void) {
        storageRef.child("\(path)/\(id)")
            .downloadURL { url, error in
                complete(url, error)
            }
    }
}
