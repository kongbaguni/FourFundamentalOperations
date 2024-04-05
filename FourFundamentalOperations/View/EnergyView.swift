//
//  EnergyView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 4/5/24.
//

import SwiftUI

struct EnergyView: View {
    let count:Int
    let length:Int
    
    var over:Int {
        if count > length {
            return count - length
        }
        return 0
    }
    var first:Int {
        if count > length {
            return length
        }
        return count
    }
    var body: some View {
        HStack (spacing:1){
            if count >= 0 {
                ForEach(0..<first, id:\.self) { idx in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 5, height: 20)
                        .foregroundColor(.orange)
                        .padding(0)
                }
                if (length > count) {
                    ForEach(0..<length-count, id:\.self) { idx in
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 5, height: 20)
                            .foregroundColor(.secondary.opacity(0.2))
                            .padding(0)
                    }
                }
                ForEach(0..<over, id:\.self) { idx in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 5, height: 10)
                        .foregroundColor(.red)
                        .padding(0)
                }
            }
        }
    }
}

#Preview {
    EnergyView(count: 3, length: 5)
}
