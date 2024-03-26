//
//  FirestoreHelper.swift
//  LivePixel
//
//  Created by Changyeol Seo on 2023/08/24.
//

import Foundation
import FirebaseFirestore
import RealmSwift
import SwiftUI

struct FirebaseFirestoreHelper {
    static var publicCollection:CollectionReference? {
        Firestore.firestore().collection("public")
    }
    
    /** 프로필 콜랙션 */
    static var profileCollection : CollectionReference {
        Firestore.firestore().collection("profile")
    }
    
    /** 내 프로필 저장소 */
    static var myProfileDocument : DocumentReference? {
        if let id = AuthManager.shared.userId {
            return profileCollection.document(id)
        }
        return nil
    }
        

}
