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
  
    var logs:[GameLogModel] = []
    
    static let shard = KTimer()
}

extension KTimer {
    var isStart:Bool {
        return logs.first?.action == .start
    }
    
    func isEnable(_ action:GameLogModel.Action)->Bool {
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
    
    func action(_ action:GameLogModel.Action, desc:String) {
        if isEnable(action) {
            logs.append(.init(action: action, time: Date(), desc: desc))
            NotificationCenter.default.post(name: .kTimerActionUpdated, object: self.logs)
            if action == .stop {
                GameRecordModel.createRecord(logs: logs) { error in
                    
                }
            }
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
    /** 타임어텍 뷰*/
    func timeAttcekTimerView (limit:TimeInterval) ->  some View {
        KTimerView(mode: .timeAttack, timeLimit: limit)
    }
    
    /** 게임결과 출력 */
    func makeGameResultView(mode:KTimerView.Mode) -> some View {
      GameResultView(mode: mode, logs: logs)
    }
}


struct KTimerView : View {
    enum Mode {
        case timeAttack
        case normal
    }
    let mode:Mode
    let timeLimit:TimeInterval?
    @State var logs:[GameLogModel] = []
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
            if let list = noti.object as? [GameLogModel] {
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
