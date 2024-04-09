//
//  GameView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/29/24.
//

import SwiftUI

struct GameView: View {
    @Environment(\.isPreview) var isPreview
    let model:GenerateStateModel?
    @State var stage:StageModel? = nil
    @State var idx:Int = 0
    @State var isFinish = false
    @State var progress:Progress? = nil
    var body: some View {
        ScrollView {
            if model?.isTimeAttack == true || stage?.isTimeAttack == true {
                KTimer.shard.timeAttcekTimerView(limit: TimeInterval(model?.count ?? stage?.count ?? 0))
            } else {
                KTimer.shard.timerView
            }
            
            if let owner = stage?.owner {
                ProfileView(profile: owner, style: .small)
            }
            if isFinish {
                KTimer.shard.listView
                
            } else if let stage = stage {
                let calc = stage.calculations[idx]
                QustionView(calc: calc) {
                    KTimer.shard.action(.lap, desc:
                                            "\(calc.rawvalue)=\(Int(calc.answer))")
                    if(idx + 1 == stage.calculations.count) {
                        isFinish = true
                        KTimer.shard.action(.stop, desc: "")
                    }
                    else if(idx + 1 < stage.calculations.count) {
                        idx += 1
                    }
                }
            } else {
                Text("now loading....")
                if let progress = progress {
                    Text("\(progress.completedUnitCount) / \(progress.totalUnitCount)")
                }
            }
        }
        .navigationTitle("game")
        .onAppear {
            if KTimer.shard.isStart {
                KTimer.shard.reset()
            }
            KTimer.shard.action(.start, desc: "")
            
            if stage == nil {
                if let model = model {
                    if isPreview == false {
                        StageModel.makeStage(model: model) { progress in
                            self.progress = progress
                        } complete: { error, model in
                            self.stage = model
                        }
                    }

                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .kTimerTimeAttackLimitOver), perform: { _ in
            self.isFinish = true
        })
    }
}

#Preview {
    GameView(model: .init(leftCount: 2, rightCount: 2, operations: [.plus], isTimeAttack: false , count: 20))
             
}
