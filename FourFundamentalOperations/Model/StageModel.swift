//
//  StageModel.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/29/24.
//

import Foundation
import RealmSwift
import SwiftUI

class StageModel : Object , ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id:String = ""
    @Persisted var value:String = ""
    @Persisted var ownerId:String = ""
    @Persisted var isTimeAtack:Bool = false
    @Persisted var regDateTimeInterval1970:Double = 0
}

extension StageModel {
    /** 계산식 리스트 */
    var calculations : [CalculationViewModel] {
        value.components(separatedBy: ",").map { item in
            return .init(item)
        }
    }
    
    /** 만든사람 정보 */
    var owner:ProfileModel? {
        Realm.shared.object(ofType: ProfileModel.self, forPrimaryKey: ownerId)
    }
    
    /** 새로 만들어진 Stage 정보 가져오기 */
    static func sync(complete:@escaping(Error?)->Void) {
        let last = Realm.shared.objects(StageModel.self).sorted(byKeyPath: "regDateTimeInterval1970", ascending: true).last
        let date = last?.regDateTimeInterval1970 ?? 0
        FirebaseFirestoreHelper.gameCollection?.whereField("regDateTimeInterval1970", isGreaterThan: date)
            .getDocuments(completion: { snapshot, error in
                if error == nil {
                    let realm = Realm.shared
                    realm.beginWrite()
                    _ = snapshot?.documents.map({ snapshot in
                        let data = snapshot.data()
                        realm.create(StageModel.self, value: data, update: .all)
                    })
                    try! realm.commitWrite()
                }
                complete(error)
            })
    }
    
    static func makeStage(
        model:GenerateStateModel,
        progress:@escaping(Progress)->Void,
        complete:@escaping (Error?,StageModel?)->Void) {
            guard let userid = AuthManager.shared.userId else {
                return
            }
            var retryCount  = 0
            
            var limit = model.count
            if model.isTimeAttack {
                limit = model.count * 2
            }
            var count = 0;
            let result = Array<Int>(0..<limit).map { idx in
                var left = Int.random(digits: model.leftCount)
                var right = Int.random(digits: model.rightCount)
                let op = model.operations.randomElement() ?? .plus
                switch op {
                case .subtrat:
                    while left <= right {
                        retryCount += 1
                        if(retryCount > 100) {
                            break
                        }
                        left = Int.random(digits: model.leftCount)
                        right = Int.random(digits: model.rightCount)
                        print("\(left) \(right)")
                    }
                case .divide:
                    while Double(left)/Double(right) != Double(left / right) || right == 1 || left <= right  {
                        if(retryCount > 100) {
                            break
                        }
                        left = Int.random(digits: model.leftCount)
                        right = Int.random(digits: model.rightCount)
                        print("\(left) \(right)")
                        retryCount += 1
                    }
                default:
                    break
                }
                count += 1
                let p = Progress(totalUnitCount: Int64(limit))
                p.completedUnitCount = Int64(count)
                progress(p)
                retryCount = 0
                return "\(left)\(op.rawValue)\(right)"
            }
            let value = result.joined(separator: ",")
            
            print(value)
            
            var data:[String:AnyHashable] = [
                "value":value,
                "ownerId": userid,
                "regDateTimeInterval1970" : Date().timeIntervalSince1970,
                "isTimeAtack" : model.isTimeAttack,
            ]
            
            data["id"] = FirebaseFirestoreHelper.gameCollection?.addDocument(data: data) { res in
                print("------------")
                print("\(data)")
                print("------------")
                
                let realm = Realm.shared
                realm.beginWrite()
                let model = realm.create(StageModel.self, value: data)
                try! realm.commitWrite()
                
                complete(res,model)
            }.documentID
            
        }
}

extension StageModel {
    var regDt:Date {
        return .init(timeIntervalSince1970: regDateTimeInterval1970)
    }
    static let Stage1 = StageModel(value: [
        "id":"1234",
        "value":"1+2,1+1,3-1",
        "ownerId":"kongbaguni",
        "isTimeAttack":false,
        "regDateTimeInterval1970":0,
        "count" : 3
    ])
    
    var operations:[String] {
        var result:[String] = []
        func isIn(str:Character)->Bool {
            value.filter { char in
                return char == str
            }.count > 0
        }
        for item in ["+","-","*","/"] {
            if isIn(str: item.first!) {
                result.append(item)
            }
        }
        return result
    }
    
    var count:Int {
        value.components(separatedBy: ",").count
    }
    
    var title:some View  {
        HStack {
            Text("\(count)")
                .bold()
                .foregroundStyle(.orange)
            if isTimeAtack {
                Text("sec")
                Text("time attack")
            }
            else {
                Text("qustions")
            }            
            Text(operations.joined(separator: ","))
                .foregroundStyle(.orange)
            Spacer()
            Text(regDt.formatted(date:.numeric, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}


#Preview {
    List {
        StageModel.Stage1.title
    }
}
