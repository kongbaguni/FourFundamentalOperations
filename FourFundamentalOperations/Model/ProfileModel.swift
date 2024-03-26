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
        var data = [
            "nickname" : nickname,
            "aboutMe" : aboutMe,
        ]
        
        guard let document = FirebaseFirestoreHelper.profileDocument else {
            return
        }
                
        document.setData(data) { error in
            do {
                data["id"] = FirebaseFirestoreHelper.rootCollection?.collectionID ?? AuthManager.shared.userId!
                
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
}
