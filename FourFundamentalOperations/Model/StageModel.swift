//
//  StageModel.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/29/24.
//

import Foundation
import RealmSwift
class StageModel : Object , ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id:String = ""
    @Persisted var value:String = ""
    @Persisted var ownerId:String = ""
    @Persisted var regDateTimeInterval1970:Double = 0
}

extension StageModel {
    var calculations : [CalculationViewModel] {
        value.components(separatedBy: ",").map { item in
            return .init(item)
        }
    }
    
    var owner:ProfileModel? {
        Realm.shared.object(ofType: ProfileModel.self, forPrimaryKey: ownerId)
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
                "regDateTimeInterval1970" : Date().timeIntervalSince1970
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



