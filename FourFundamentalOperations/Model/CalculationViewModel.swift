//
//  CalculationModel.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/28/24.
//

import Foundation
import SwiftUI

struct CalculationViewModel {
    enum Operator: String, CaseIterable {
        case plus = "+"
        case subtrat = "-"
        case divide = "/"
        case multiply = "*"
        
        var printingString : String {
            switch self {
            case .divide:
                return "÷"
            case .multiply:
                return "✕"
            default:
                return self.rawValue
            }
        }
        
        var image:Image {
            switch self {
            case .plus:
                return .init(systemName: "plus")
            case .divide:
                return .init(systemName: "divide")
            case .subtrat:
                return .init(systemName: "minus")
            case .multiply:
                return .init(systemName: "multiply")
            }
        }
    }
    
    let left:Int
    let `operator`:Operator
    let right:Int
    
    init(left: Int, operator op :Operator,  right: Int) {
        self.left = left
        self.right = right
        self.operator = op
    }
    
    init(_ value:String) {
        var left = 0
        var right = 0
        var oper = Operator.plus
        
        for op in Operator.allCases {
            let result = value.components(separatedBy: op.rawValue)
            if result.count == 2 {
                left = NSString(string: result.first!).integerValue
                right = NSString(string: result.last!).integerValue
                oper = op
            }
        }
        self.operator = oper
        self.left = left
        self.right = right
    }
}


extension CalculationViewModel {
    var answer : Double {
        switch self.operator {
        case .divide:
            return Double(left) / Double(right)
        case .multiply:
            return Double(left * right)
        case .plus:
            return Double(left + right)
        case .subtrat:
            return Double(left - right)
        }
    }
    
    var view: some View {
        func makeStyle(_ text:Text) -> some View {
            return text
                .font(.system(size: 30).bold())
                .foregroundStyle(.cardForeground)
                .padding(10)
                .background{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.cardBackground)
                        .shadow(radius: 10, x:5, y: 5)
                }
                .frame(minWidth: 50, maxHeight: 70)
                
        }
        return HStack {
            makeStyle(Text("\(left)"))
                
            
            self.operator.image
                .resizable()
                .scaledToFit()
                .frame(width:15, height: 15)
                .foregroundColor(.secondary)
                .padding(5)
                
            makeStyle(Text("\(right)"))
        }
    }
}

#Preview {
    VStack {
        CalculationViewModel("10/5").view
        CalculationViewModel("10*5").view
        CalculationViewModel("10-5").view
        CalculationViewModel("10+5").view
    }
}
