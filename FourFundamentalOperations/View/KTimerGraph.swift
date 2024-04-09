//
//  KTimerGraph.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 4/9/24.
//

import SwiftUI

struct KTimerGraph : View {
    let value:Double
    let max:Double
    func getSize(geometry:GeometryProxy)->CGFloat {
        let w:CGFloat = geometry.size.width / max * value
        if w > geometry.size.width {
            return geometry.size.width
        }
        return w
    }
    
    var graphColor:Color {
        value < max ? .orange : .red
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(.gray)
                let size = getSize(geometry: geometry)
                if size > 0 {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: size, height: geometry.size.height)
                        .foregroundColor(graphColor)
                }
            }
        })
    }
    
}

#Preview {
    KTimerGraph(value: 20, max: 40)
}
