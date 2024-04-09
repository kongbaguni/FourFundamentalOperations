//
//  KTimer.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 4/8/24.
//

import Foundation
import SwiftUI

extension Notification.Name {
    static let kTimerActionUpdated = Notification.Name("kTimerActionUpdated_observer")
    static let kTimerTimeAttackLimitOver = Notification.Name("kTimerTimeAttackLimitOver_observer")
}


class KTimer {
    enum Action {
        case start
        case lap
        case stop
    }
    
    struct Log : Hashable {
        static func == (lhs:Log, rhs:Log)->Bool {
            return lhs.action == rhs.action && lhs.time == rhs.time
        }
        let action:Action
        let time:Date
        let desc:String
        
        func getDistance(data:[Log])->TimeInterval {
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
    }
    
    var logs:[Log] = []
    
    static let shard = KTimer()
}

extension KTimer {
    var isStart:Bool {
        return logs.first?.action == .start
    }
    
    func isEnable(_ action:Action)->Bool {
        let la = logs.last?.action
        switch action {
        case .start:
            return logs.count == 0
        case .stop:
            return logs.count > 0 && la != .stop
        case .lap:
            return la == .start || la == .lap
        }
    }
    
    func action(_ action:Action, desc:String) {
        if isEnable(action) {
            logs.append(.init(action: action, time: Date(), desc: desc))
            NotificationCenter.default.post(name: .kTimerActionUpdated, object: self.logs)
        }
    }
    
    func reset() {
        logs.removeAll()
        NotificationCenter.default.post(name: .kTimerActionUpdated, object: self.logs)
    }
    
    var testButtons : some View {
        Group {
            Button {
                if KTimer.shard.logs.count == 0 {
                    KTimer.shard.action(.start, desc: "")
                } else {
                    KTimer.shard.action(.lap, desc: "lap test")
                }
            } label: {
                Image(systemName: "play")
            }
            Button {
                KTimer.shard.action(.stop, desc: "")
            } label: {
                Image(systemName: "stop")
            }
            Button {
                KTimer.shard.reset()
            } label: {
                Image(systemName: "trash")
            }
        }
    }
        
    /** 타이머 뷰*/
    var timerView: some View {
        KTimerView(mode: .normal, timeLimit: nil)
    }
    
    func timeAttcekTimerView (limit:TimeInterval) ->  some View {
        KTimerView(mode: .timeAttack, timeLimit: limit)
    }
    
    var listView : some View {
        Group {
            let qcount = logs.filter { log in
                log.action == .lap
            }.count
            Text(String(
                format:NSLocalizedString("Got %d current", comment:"게임 결과"),qcount))
            
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


fileprivate struct KTimerView : View {
    enum Mode {
        case timeAttack
        case normal
    }
    let mode:Mode
    let timeLimit:TimeInterval?
    @State var logs:[KTimer.Log] = []
    @State var curDate:Date = Date()
    @State var timer:Timer? = nil
    
    func makeView(time:Double, max: Double) -> some View {
        HStack {
            Text(String(format: "%0.1f", time))
                .frame(width:120, height: 60)
                .font(.caption)
                .foregroundStyle(.orange)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.secondary, lineWidth: 2.0)
                }
            KTimerGraph(value: time, max: max)
        }
    }
    
    var body: some View {
        Group {
            switch mode {
            case .timeAttack:
                if let firstTime = logs.first?.time.timeIntervalSince1970 {
                    let now = curDate.timeIntervalSince1970
                    let interval = now - firstTime
                    let limit = Double(self.timeLimit ?? 0)
                    if limit - interval > 0 {
                        makeView(time: limit - interval, max: limit)
                    }
                }
                
            case .normal:
                if let time = logs.last?.time.timeIntervalSince1970 {
                    if logs.last?.action == .lap || logs.last?.action == .start {
                        makeView(time: curDate.timeIntervalSince1970 - time, max: 20)
                    }
                }

            }
            
        }
        .onAppear {
            if timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { timer in
                    self.curDate = Date()
                    
                    if mode == .timeAttack {
                        if let firstTime = logs.first?.time.timeIntervalSince1970 {
                            let now = curDate.timeIntervalSince1970
                            let interval = now - firstTime
                            if interval >= self.timeLimit ?? 0 {
                                KTimer.shard.action(.stop, desc: "")
                                NotificationCenter.default.post(name: .kTimerTimeAttackLimitOver, object: nil)
                                self.timer?.invalidate()
                                self.timer = nil
                            }
                        }
                    }
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
        .onReceive(NotificationCenter.default.publisher(for: .kTimerActionUpdated), perform: { noti in
            if let list = noti.object as? [KTimer.Log] {
                logs = list
            }
        })
    }
}


#Preview {
    return ScrollView {
        VStack {
            
//            KTimer.shard.timerView
            
//            KTimer.shard.listView
            
            KTimer.shard.timeAttcekTimerView(limit: 30)
            HStack {
                KTimer.shard.testButtons
            }
        }
    }
}
