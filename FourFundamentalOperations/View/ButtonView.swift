//
//  ButtonView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/6/24.
//

import SwiftUI

struct ButtonView: View {
    enum Style {
        case primary
        case secondary
    }
    
    let image:Image
    let title:Text
    let style:Style
    let onclick:()->Void
    
    var buttonBackgroundColor:Color {
        switch style {
        case .primary:
            return .buttonPrimaryBackground
        case .secondary:
            return .buttonSecondaryBackground
        }
    }
    
    var buttonTextColor:Color {
        switch style {
        case .primary:
            return .buttonPrimaryText
        case .secondary:
            return .buttonSecondaryText
        }
    }
    
    var buttonBorderColor:Color {
        switch style {
        case .primary:
            return .buttonPrimaryBorder
        case .secondary:
            return .buttonSecondaryBorder
        }
    }
    
    
    var body: some View {
        GeometryReader { geomentry in
            Button(action: {
                onclick()
            }, label: {
                HStack {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.symbol1, .symbol2, .symbol3)
                    
                    title
                        .foregroundStyle(buttonTextColor)
                }
                .padding(10)
                .frame(width: geomentry.size.width)
                
            })
            
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(buttonBackgroundColor)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(buttonBorderColor, lineWidth: 2.0)
                
            }
        }.frame(height: 50)
        
    }
}

#Preview {
    VStack {
        HStack {
            ButtonView(image: .init("GoogleLogo"),
                       title: .init("signin"),
                       style: .primary
                       
            ) {
                print("signin")
                
            }
            ButtonView(image: .init(systemName: "apple.logo"),
                       title: .init("signin"),
                       style: .secondary
            
            ) {
                print("signin")
                
            }
        }
        ButtonView(image: .init(systemName: "signature"),
                   title: .init("signin"),
                   style: .secondary
        ) {
            print("signin")
            
        }
    }.padding(10)
}
