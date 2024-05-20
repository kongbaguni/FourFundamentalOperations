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
    @Persisted var regDateTimeInterval1970:Double = 0
    @Persisted var timeLimit:Double = 0
}

extension StageModel {
    var isTimeAttack:Bool {
        timeLimit > 0
    }
    
    /** 계산식 리스트 */
    var calculations : [CalculationViewModel] {
        value.components(separatedBy: ",").map { item in
            return .init(item)
        }
    }
    
    func getLengthCalc(operator op:CalculationViewModel.Operator)->Int {
        calculations.filter { model in
            model.operator == op
        }.count
    }
    
    /** 만든사람 정보 */
    var owner:ProfileModel? {
        Realm.shared.object(ofType: ProfileModel.self, forPrimaryKey: ownerId)
    }
    
    enum Difficulty : Int{
        case easy = 1
        case normal = 2
        case hard = 3
        case ultra = 4
        var imageView : some View {
            EnergyView(count: self.rawValue, length: 4)
        }
    }
    
    /** 난이도 */
    var difficulty : Difficulty {
        
        let plusPoint = getLengthCalc(operator: .plus)
        let minusPoint = getLengthCalc(operator: .subtrat)
        let multiplyPoint = getLengthCalc(operator: .multiply) * 10
        let dividePoint = getLengthCalc(operator: .divide) * 10
        let point = (plusPoint + minusPoint + multiplyPoint + dividePoint) / calculations.count
        
        
        let value = value.components(separatedBy: ",").first
        switch value?.count ?? 0 + point {
        case 0,1,2,3:
            return .easy
        case 4, 5:
            return .normal
        case 6, 7:
            return .hard
        default:
            return .ultra
        }
    }
    
    /** 새로 만들어진 Stage 정보 가져오기 */
    static func sync(complete:@escaping(Error?)->Void) {
        let last = Realm.shared.objects(StageModel.self).sorted(byKeyPath: "regDateTimeInterval1970", ascending: true).last
        let date = last?.regDateTimeInterval1970 ?? 0
        print("sync stage : \(date)")
        FirebaseFirestoreHelper.gameCollection?.whereField("regDateTimeInterval1970", isGreaterThan: date)
            .getDocuments(completion: { snapshot, error in
                if error == nil {
                    let realm = Realm.shared
                    realm.beginWrite()
                    _ = snapshot?.documents.map({ snapshot in
                        var data = snapshot.data()
                        data["id"] = snapshot.documentID
                        print("sync stage  : \(data))")
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
                "timeLimit" : model.isTimeAttack ? model.count : 0,
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
        "value":"11+22,21+1,33-1",
        "ownerId":"kongbaguni",
        "isTimeAttack":true,
        "regDateTimeInterval1970":0,
        "timeLimit" : 20,
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
            difficulty.imageView
            
            Text("\(isTimeAttack ? Int(timeLimit) : count )")
                .bold()
                .foregroundStyle(isTimeAttack ? .teal : .orange)
            if isTimeAttack {
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
