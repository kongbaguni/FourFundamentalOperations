//
//  AccountModel.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/7/23.
//

import Foundation
import RealmSwift

struct AccountModel {
    let userId:String
    let accountRegDt:Date?
    let accountLastSigninDt:Date?
    let email:String?
    let phoneNumber:String?
    let photoURL:URL?
    let isAnonymous:Bool
}


extension AccountModel {
    var myProfile:ProfileModel? {
        Realm.shared.object(ofType: ProfileModel.self, forPrimaryKey: userId)
    }
    
    func getMyProfileImageURL(complete:@escaping(URL?,Error?)->Void) {
        FirebaseFirestorageHelper.shared.getURL(path: "profile", id: userId) { url, error in
            complete(url ?? photoURL,error)
        }
    }
}
