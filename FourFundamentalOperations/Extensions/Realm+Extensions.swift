//
//  Realm+Extensions.swift
//  LivePixel
//
//  Created by Changyeol Seo on 2023/08/24.
//

import Foundation
import RealmSwift

extension Realm {
    static var shared:Realm {
        let config = Realm.Configuration(schemaVersion:4) { migration, oldSchemaVersion in
            if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: StageModel.className()) { oldObject, newObject in
                    newObject!["timeLimit"] = 0
                }
            }
        }
        Realm.Configuration.defaultConfiguration = config
        do {
            return try Realm(configuration: config)
        } catch {
            print(error.localizedDescription)
            abort()
        }
    }
}
