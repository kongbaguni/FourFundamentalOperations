//
//  ButtonView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/6/24.
//

import SwiftUI

struct ButtonView: View {
    let image:Image
    let title:Text
    let style:RoundedBorderImageLabelView.Style
    let onclick:()->Void
    
    var body: some View {
        Button(action: {
            onclick()
        }, label: {
            RoundedBorderImageLabelView(image: image, title: title, style: style)
        })
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
