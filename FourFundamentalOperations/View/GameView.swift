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
    
    @State var profileId:String? = nil
    
    var body: some View {
        ScrollView {
            if isPreview == false {
                if profileId != nil {
                    if let owner = stage?.owner {
                        HStack {
                            Text("creator")
                                .font(.subheadline)
                                .bold()
                                .padding()
                            ProfileView(profile: owner, style: .small)
                        }
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 2)
                        }
                    }
                }
            }

            if model?.isTimeAttack == true || stage?.isTimeAttack == true {
                var limit:TimeInterval {
                    if let c = model?.count {
                        return TimeInterval(Double(c))
                    }
                    if let c = stage?.timeLimit {
                        return TimeInterval(c)
                    }
                    return 0.0
                }
                KTimer.shard.timeAttcekTimerView(limit: limit)
            } else {
                KTimer.shard.timerView
            }
            if isFinish {
                KTimer.shard.makeGameResultView(mode: (model?.isTimeAttack ?? stage?.isTimeAttack ?? false) ? .timeAttack : .normal )
                
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
            if let id = stage?.ownerId {
                ProfileModel.getProfile(id: id) { error in
                    if error == nil {
                        profileId = id
                    }
                }
            }
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
    
    GameView(model: nil, stage: StageModel.Stage1)    
             
}
