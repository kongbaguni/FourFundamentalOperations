//
//  File.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/25/24.
//

import Foundation
import RealmSwift


class ProfileModel : Object , ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var nickname = ""
    @Persisted var aboutMe = ""
}

extension ProfileModel {
    static func getProfile(id:String, complete:@escaping (Error?)->Void) {
        FirebaseFirestoreHelper.profileCollection.document(id).getDocument { snapShot, error in
            if let shot = snapShot, var data = shot.data() {
                data["id"] = shot.documentID
                let realm = Realm.shared
                realm.beginWrite()
                realm.create(ProfileModel.self, value: data, update: .all)
                try! realm.commitWrite()
            }
            complete(error)
        }
    }
    
    static var myProfile:ProfileModel? {
        
        guard let id = AuthManager.shared.userId else {
            return nil
        }
        if let model =  Realm.shared.object(ofType: ProfileModel.self, forPrimaryKey: id) {
            return model
        }
        
        let realm = Realm.shared
        realm.beginWrite()
        let result = realm.create(ProfileModel.self, value: ["id":id])
        try! realm.commitWrite()
        return result
    }
    
    static func make(nickname:String, aboutMe:String, complete:@escaping (_ error:Error?)->Void) {
        guard let userId = AuthManager.shared.userId else {
            return
        }
        
        var data = [
            "nickname" : nickname,
            "aboutMe" : aboutMe,
        ]
        
        guard let document = FirebaseFirestoreHelper.myProfileDocument else {
            return
        }
                
        document.setData(data) { error in
            do {
                data["id"] = userId
                
                let realm = Realm.shared
                realm.beginWrite()
                realm.create(ProfileModel.self, value: data, update: .all)
                try realm.commitWrite()

            } catch {
                complete(error)
                return
            }
            complete(error)
        }
    }
    
    func getProfileImageUrl(complete: @escaping(URL?,Error?)->Void) {
        guard let id = AuthManager.shared.userId else {
            return
        }
        FirebaseFirestorageHelper.shared.getURL(path: "profileImage", id: id) { url, error in
            complete(url,error)
        }        
    }
    
    static var Test:ProfileModel {
        return .init(value: [
            "id":"qwe123qwe",
            "nickname":"콩바구니",
            "aboutMe":"안녕"
        ])
    }
}
