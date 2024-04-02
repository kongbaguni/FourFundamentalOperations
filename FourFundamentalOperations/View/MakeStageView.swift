//
//  MakeStageView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/29/24.
//

import SwiftUI

struct MakeStageView: View {
    
    var qustions:[String] = []
    @State var leftCount = 1
    @State var rightCount = 1
    @State var operations:[String] = []
    @State var isTimeAttack = false
    @State var count = 20
    
    var oper:[CalculationViewModel.Operator] {
        operations.map { str in
            return CalculationViewModel.Operator(rawValue: str) ?? .plus
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                KNumberSelect(label: .init("leftCount"), select: $leftCount)
                KNumberSelect(label: .init("rightCount"), select: $rightCount)
                HStack {
                    Text("Operator")
                        .font(.subheadline).foregroundStyle(.secondary)
                    KSelectInput(items: ["+", "-", "*", "/"], selection: $operations)
                }
                Toggle(.init("time attack"), isOn: $isTimeAttack)
                if isTimeAttack {
                    KNumberSelect(label: .init("time limit"), select: $count)
                } else {
                    KNumberSelect(label: .init("qustion count"), select: $count)
                }
                
                NavigationLink {
                    GameView(model: .init(leftCount: leftCount, rightCount: rightCount, operations: oper, isTimeAttack: isTimeAttack, count: count))
                    
                } label: {
                    RoundedBorderImageLabelView(image: .init(systemName: "square.and.pencil"), title: .init("generate stage"), style: .primary)
                }
            }
            .padding()
            
        }        
    }
}

#Preview {
    MakeStageView()
}
