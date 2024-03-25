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
        if let id = AuthManager.shared.userId {
            return Realm.shared.object(ofType: ProfileModel.self, forPrimaryKey: id)
        }
        return nil
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
                let result = realm.create(ProfileModel.self, value: data, update: .all)
                try realm.commitWrite()
                NotificationCenter.default.post(name: .profileDidUpdate, object: result)

            } catch {
                complete(error)
                return
            }
            complete(error)
        }
    }
}


extension Notification.Name {
    static let profileDidUpdate = Notification.Name("profileDidUpdate_observer")
}
