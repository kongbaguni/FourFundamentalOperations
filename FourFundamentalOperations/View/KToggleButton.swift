//
//  KToggleButton.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/29/24.
//

import SwiftUI

struct KToggleButton: View {
    let label:Text
    @Binding var isOn:Bool
    @State var isTouched:Bool = false
    var body: some View {
        label
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isOn ? .orange : .gray)
            }
            .foregroundColor(.primary)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isTouched ? Color.primary : Color.clear,  lineWidth: 2.0)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        self.isTouched = true
                        isOn.toggle()
                    }
                    .onEnded { _ in
                        self.isTouched = false
                    }
            )
            .animation(.easeInOut, value: isTouched)
            
    }
}

#Preview {
    VStack {
        KToggleButton(label: .init("바나나"), isOn: .constant(true))
        KToggleButton(label: .init("몽키"), isOn: .constant(false ))
        KToggleButton(label: .init("test"), isOn: .constant(false ))

    }
}
