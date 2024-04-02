//
//  QustionView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/29/24.
//

import Foundation
import SwiftUI
extension Notification.Name {
    static let onTouchupNumberButton = Notification.Name("onTouchupNumberButton_observer")
}

struct NumberInputView : View {
    let data:[[AnyHashable]] = [
        [7,8,9],
        [4,5,6],
        [1,2,3],
        [".",0,"del"]
    ]
    @Binding var input:String {
        didSet {
            result = NSString(string: input).doubleValue
        }
    }
    @Binding var result:Double
    
    
    func inputButtn(item:AnyHashable) {
        switch item as? String {
        case "del":
            if !input.isEmpty {
                input.removeLast()
            }
        case "." :
            if input.components(separatedBy: ".").count < 2 {
                input += "."
            }
        default:
            if let number = item as? Int {
                input += "\(number)"
            }
        }

    }
    
    var body: some View {
        VStack {
            ForEach(data, id:\.self) { row in
                HStack {
                    ForEach(0..<row.count, id: \.self) { idx in
                        let item = row[idx]
                        KButton(label: .init("\(item)"), style: .primary) { on in
                            if(on) {
                                inputButtn(item: item)
                                NotificationCenter.default.post(name: .onTouchupNumberButton, object: result)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct QustionView : View {
    let calc:CalculationViewModel
    @State var resultStr:String = ""
    @State var result:Double = 0
    let onClear:()->Void
    var isCurrent:Bool {
        calc.answer == result        
    }
    
    var body: some View {
        VStack {
            HStack {
                calc.view
                Image(systemName: "equal")
                    .resizable()
                    .scaledToFit()
                    .frame(width:15, height: 15)
                    .foregroundColor(.secondary)
                    .padding(5)
                
                Text(resultStr)
                    .font(.system(size: 30).bold())
                    .foregroundStyle(.cardForeground)
                    .padding(10)
                    .background{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                isCurrent ? Color.teal :
                                Color.cardBackground
                            )
                            .shadow(radius: 10, x:5, y: 5)
                    }
                    .frame(minWidth: 50, maxHeight: 70)
            }
            NumberInputView(input: $resultStr, result: $result)
        }
        .onAppear {
            print("start \(calc.rawvalue)")
        }
        .onReceive(NotificationCenter.default.publisher(for: .onTouchupNumberButton, object: nil), perform: { noti in
            print(noti.object ?? "")
            if self.isCurrent {
                print("맞았다! 정답!")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    resultStr = ""
                    result = 0
                    self.onClear()
                }

            }
        })
    }
}

#Preview {
    VStack {
        QustionView(calc: .init("5*10")) {
            
        }
    }
}
