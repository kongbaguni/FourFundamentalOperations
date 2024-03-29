//
//  KButton.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/29/24.
//

import SwiftUI

struct KButton: View {
    enum Style {
        case primary
        case secondary
    }
    
    let label:Text
    let style:Style
    let onClick:(Bool)->Void
    
    @State var size:CGFloat = 50
    var background:Color {
        switch style {
        case .primary:
            return isTouched ? .buttonPrimaryText : .buttonPrimaryBackground
        case .secondary:
            return isTouched ? .buttonSecondaryText : .buttonSecondaryBackground
        }
    }
    
    var foreground:Color {
        switch style {
        case .primary:
            return isTouched ? .buttonPrimaryBackground : .buttonPrimaryText
        case .secondary:
            return isTouched ? .buttonSecondaryBackground: .buttonSecondaryText
            
        }
    }
    
    var border:Color {
        switch style {
        case .primary:
            return .buttonPrimaryBorder
        case .secondary:
            return .buttonSecondaryBorder
        }
    }
    
    @State var text:Color = Color.buttonPrimaryText
    @State var isTouched = false
    
    var body: some View {
        label
            .frame(width:size, height: size)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(background)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(border, lineWidth: 2)
            }
            .foregroundStyle(foreground)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if(!self.isTouched) {
                            onClick(true)
                        }
                        self.isTouched = true
                    }
                    .onEnded { _ in
                        self.isTouched = false
                        onClick(false)
                    }
            )
            .animation(.easeInOut,value: isTouched)
    }
}

#Preview {
    HStack {
        KButton(label: .init("0"), style: .primary) { touch in
            print("test \(touch)")
        }
        KButton(label: .init("1"), style: .secondary) { touch in
            print("test \(touch)")
        }
    }
}
