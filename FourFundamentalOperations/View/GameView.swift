//
//  GameView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/29/24.
//

import SwiftUI

struct GameView: View {
    let model:GenerateStateModel?
    @State var stage:StageModel? = nil
    @State var idx:Int = 0
    @State var isFinish = false
    @State var progress:Progress? = nil
    var body: some View {
        VStack {
            if isFinish {
                Text("finish")
            } else if let stage = stage {
                QustionView(calc: stage.calculations[idx]) {
                    if(idx + 1 == stage.calculations.count) {
                        isFinish = true
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
            if stage == nil {
                if let model = model {
                    StageModel.makeStage(model: model) { progress in
                        self.progress = progress
                        
                    } complete: { error, model in
                        self.stage = model
                    }

                }
            }
        }
    }
}

#Preview {
    GameView(model: .init(leftCount: 2, rightCount: 2, operations: [.plus], isTimeAttack: false , count: 20))
             
}
