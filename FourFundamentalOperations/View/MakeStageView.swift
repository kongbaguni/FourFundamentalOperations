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
    @State var operators:[String] = []
    @State var isTimeAttack = false
    @State var count = 20
    
    var oper:[CalculationViewModel.Operator] {
        operators.map { str in
            return CalculationViewModel.Operator(rawValue: str) ?? .plus
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                KNumberSelect(label: .init("leftCount"), range: 1..<4, select: $leftCount)
                KNumberSelect(label: .init("rightCount"), range: 1..<4, select: $rightCount)
                HStack {
                    Text("Operator")
                        .font(.subheadline).foregroundStyle(.secondary)
                    KSelectInput(items: ["+", "-", "*", "/"], selection: $operators)
                }
                Toggle(isOn: $isTimeAttack) {
                    Text("time attack")
                }

                if isTimeAttack {
                    KNumberSelect(label: .init("time limit"), range: 20..<121, select: $count)
                } else {
                    KNumberSelect(label: .init("qustion count"), range: 5..<31, select: $count)
                }
                
                NavigationLink {
                    GameView(model: .init(leftCount: leftCount, rightCount: rightCount, operations: oper, isTimeAttack: isTimeAttack, count: count))
                    
                } label: {
                    RoundedBorderImageLabelView(image: .init(systemName: "square.and.pencil"), title: .init("generate game"), style: .primary)
                }
                .disabled(operators.count == 0)
                .opacity(operators.count == 0 ? 0.2 : 1.0)
            }
            .padding()
            
        }    
        .navigationTitle("create new game")
    }
}

#Preview {
    MakeStageView()
}
