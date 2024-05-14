//
//  LogModel.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 5/14/24.
//

import Foundation
import SwiftUI

struct GameLogModel : Hashable {
    enum Action : String, CaseIterable {
        case start = "start"
        case lap = "lap"
        case stop = "stop"
    }

    static func == (lhs:GameLogModel, rhs:GameLogModel)->Bool {
        return lhs.action == rhs.action && lhs.time == rhs.time
    }
    let action:Action
    let time:Date
    let desc:String
    
    func getDistance(data:[GameLogModel])->TimeInterval {
        if data.count <= 1 {
            return 0
        }
        if let idx = data.firstIndex(of: self) {
            for i in 0..<idx {
                let b = data[idx - i - 1]
                switch b.action {
                case .start, .lap:
                    return  self.time.timeIntervalSince1970 - b.time.timeIntervalSince1970
                default:
                    break
                }
            }
        }
        
        return 0
    }
    var stringValue: String {
        return "\(action.rawValue),\(time.timeIntervalSince1970),\(desc)"
    }
    
    init(action: Action, time: Date, desc: String) {
        self.action = action
        self.time = time
        self.desc = desc
    }
    
    init(string:String) {
        let values = string.components(separatedBy: ",")
        if values.count == 3 {
            self.action = .init(rawValue: values[0])!
            self.time = .init(timeIntervalSince1970: NSString(string: values[1]).doubleValue)
            self.desc = values[2]
        } else {
            abort()
        }
    }
}


#Preview {
    VStack {
        let model:GameLogModel = .init(action: .lap, time: Date(), desc: "test")
        let string = model.stringValue
        Text(string)
        Text(GameLogModel(string: string).stringValue)
    }
}
