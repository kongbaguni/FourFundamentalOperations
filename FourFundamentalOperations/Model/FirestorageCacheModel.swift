//
//  FirestorageCacheModel.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/27/24.
//

import Foundation
import RealmSwift

class FirestorageCacheModel : Object , ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var url:String = ""
    @Persisted var updateDt:Date = Date()
}

extension FirestorageCacheModel {
    var isExpired:Bool {
        let now = Date()
        let interval = now.timeIntervalSince1970 - updateDt.timeIntervalSince1970
        return interval > 86400
    }
}
