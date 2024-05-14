//
//  GameResultView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 5/14/24.
//

import SwiftUI

struct GameResultView: View {
    let mode:KTimerView.Mode
    let logs:[GameLogModel]
    
    var fullTime:TimeInterval {
        if let first = logs.first?.time,
           let last = logs.last?.time {
            print("-----------------")
            print(last.timeIntervalSince1970 - first.timeIntervalSince1970)
            return last.timeIntervalSince1970 - first.timeIntervalSince1970
        }
        return 0
    }

    var body: some View {
        Group {
            let qcount = logs.filter { log in
                log.action == .lap
            }.count
            
            switch mode {
            case .timeAttack:
                Text(String(
                    format:NSLocalizedString("Got %d current", comment:"게임 결과"),qcount))
            case .normal:
                Text(String(
                    format:NSLocalizedString("It took %0.2f seconds", comment: "게임 결과"), fullTime))
            }
            
            
            ForEach(logs, id: \.self) { log in
                let sec = log.getDistance(data: self.logs)
                switch log.action {
                case .lap:
                    HStack {
                        Text(log.desc)
                        KTimerGraph(value: log.getDistance(data: self.logs), max: 20.0)
                        Text(String(format:NSLocalizedString("%0.2f sec", comment: "초단위 포메팅"),sec))
                            .frame(width: 120, height: 25)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.secondary,lineWidth: 2.0)
                            }
                        
                    }.frame(height: 20)
                default:
                    HStack {
                        
                    }

                }
            }
        }.padding()

    }
}

#Preview {
    GameResultView(mode: .normal, logs: [
        .init(action: .start, time: .init(timeIntervalSince1970: 100), desc: ""),
        .init(action: .lap, time: .init(timeIntervalSince1970: 200), desc: "1+1"),
        .init(action: .lap, time: .init(timeIntervalSince1970: 500), desc: "3+1"),
        .init(action: .stop, time: .init(timeIntervalSince1970: 510), desc: ""),

    ])
}
