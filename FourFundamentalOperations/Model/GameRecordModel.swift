//
//  GameRecordModel.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 5/14/24.
//

import Foundation
import SwiftUI
import RealmSwift

class GameRecordModel : Object {
    @Persisted(primaryKey: true) var id:String = ""
    @Persisted var ownerId:String = ""
    @Persisted var value:String = ""
    @Persisted var regDatetimeIntervalSince1970:Double = Date().timeIntervalSince1970
}

extension GameRecordModel {
    var logs:[GameLogModel] {
        value.components(separatedBy: "/").map { value in
            .init(string: value)
        }
    }
    
    static func createRecord(logs:[GameLogModel], complete:@escaping (Error?)->Void) {
        guard let id = AuthManager.shared.userId else {
            complete(CustomError.notAuth)
            return
        }
        let value = logs.map { model in
            model.stringValue
        }.joined(separator: "/")
        
        var data:[String:AnyHashable] = [
            "ownerId" : id,
            "value" : value,
            "regDatetimeIntervalSince1970" : Date().timeIntervalSince1970
        ]
        
        data["id"] = FirebaseFirestoreHelper.gameRecordCollection?.addDocument(data: data, completion: { error in
            if error == nil {
                let realm = Realm.shared
                realm.beginWrite()
                realm.create(GameRecordModel.self, value: data, update: .all)
                try! realm.commitWrite()
            }
            complete(error)
        }).documentID
        
    }
        
}

#Preview {
    VStack {
        let logs:[GameLogModel] = [
            .init(action: .start, time: .init(timeIntervalSince1970: 1000), desc: "test"),
            .init(action: .lap, time: .init(timeIntervalSince1970: 1002), desc: "1+1"),
            .init(action: .lap, time: .init(timeIntervalSince1970: 1010), desc: "2+1"),
            .init(action: .stop, time: .init(timeIntervalSince1970: 1002), desc: "1+1"),
        ]
        
        let value = logs.map { model in
            model.stringValue
        }.joined(separator: "/")
        var model = GameRecordModel(value: [
            "id":"test",
            "value":value,
            "regDatetimeIntervalSince1970":Date().timeIntervalSince1970
        ])
        Text("\(model.dictionmaryValue)")
        
        ForEach(model.logs, id:\.self) { log in
            Text(log.stringValue)
        }
        
        GameResultView(mode: .normal, logs: logs)
        
    }
}
