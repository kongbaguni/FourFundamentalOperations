//
//  FirebaseFirestorageHelper.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/26/24.
//

import Foundation
import FirebaseStorage
import SwiftUI
import RealmSwift

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
    
    func uploadImage(image:Image, contentType:ContentType, size:CGSize = .init(width: 300, height: 300) , uploadPath:String, id:String, complete:@escaping(_ error:Error?)->Void) {
        let uiimage = image.asUIImage().resize(size)
        
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
            let realm = Realm.shared
            let key = "\(uploadPath)/\(id)"
            
            if let item = realm.object(ofType: FirestorageCacheModel.self, forPrimaryKey: id) {
                realm.beginWrite()
                realm.delete(item)
                try! realm.commitWrite()
            }
            self.getURL(path: uploadPath, id: id) { url, error in
                if snapshot.error ?? error == nil  {
                    NotificationCenter.default.post(name: .profilePhotoDidUpdated,  object:nil, userInfo : [
                        "url" : url?.absoluteString ?? "",
                        "id" : id
                    ])
                }
                complete(snapshot.error ?? error)
            }
        }
        task.observe(.failure) { snapshot in
            complete(snapshot.error)
        }
    }
    
    
    func getURL(path:String, id:String, complete:@escaping(_ url:URL?, _ error:Error?)->Void) {
        let key = "\(path)/\(id)"
        if let item = Realm.shared.object(ofType: FirestorageCacheModel.self, forPrimaryKey: id) {
            if !item.isExpired {
                complete(URL(string: item.url), nil)
                return
            }
        }
        
        storageRef.child(key)
            .downloadURL { url, error in
                if let url = url {
                    let realm = Realm.shared
                    realm.beginWrite()
                    realm.create(FirestorageCacheModel.self, value: [
                        "id":id,
                        "url":url.absoluteString,
                        "updateDt":Date()
                    ], update: .all)
                    try! realm.commitWrite()
                }
                complete(url, error)
            }
    }
}

extension Notification.Name {
    static let profilePhotoDidUpdated = Notification.Name("profilePhotoDidUpdated_observer")
}
