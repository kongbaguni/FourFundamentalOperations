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

    static var profileDocument : DocumentReference? {
        rootCollection?.document("profile")
    }
    
    static var rootDocument:DocumentReference? {
        rootCollection?.document("data")
    }
    

}
