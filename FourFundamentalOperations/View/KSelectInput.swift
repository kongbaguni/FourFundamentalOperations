//
//  KSelectInput.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/29/24.
//

import SwiftUI

struct KSelectInput: View {
    let items:[String]
    @Binding var selection:[String]
    @State var isOn:[Bool] = []
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack {
                if(isOn.count == items.count) {
                    ForEach(0..<items.count,id:\.self) {idx in
                        KToggleButton(label: .init("\(items[idx])"), isOn: $isOn[idx])
                    }
                }
            }
        }
        .onChange(of: isOn) { value in
            print(value)
            var result:[String] = []
            for (idx, isOn) in isOn.enumerated() {
                if isOn {
                    result.append(items[idx])
                }
            }
            selection = result
        }
        .onAppear {
            while(isOn.count < items.count) {
                isOn.append(false)
            }
        }
    }
}

#Preview {
    KSelectInput(items: ["곱하기","뺴기","나누기","멸치"], selection: .constant([]))
}
