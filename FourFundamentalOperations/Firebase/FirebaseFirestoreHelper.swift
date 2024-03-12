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
    static var rootCollection:CollectionReference? {
        guard let userid = AuthManager.shared.userId else {
            return nil
        }
        return Firestore.firestore().collection(userid)
    }
    
    static var rootDocument:DocumentReference? {
        rootCollection?.document("data")
    }
    
    static var pointCollection:CollectionReference? {
        rootDocument?.collection("point")
    }
    
    static var codesCollection:CollectionReference? {
        rootDocument?.collection("codes")
    }
    
    static var tagsCollection:CollectionReference? {
        rootDocument?.collection("tags")
    }
    
    static var themeCollection:CollectionReference {
        Firestore.firestore().collection("theme")
    }
}
