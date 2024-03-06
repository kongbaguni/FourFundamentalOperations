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
    let onclick:()->Void
    var body: some View {
        GeometryReader { geomentry in
            Button(action: {
                onclick()
            }, label: {
                HStack {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.symbol1, .symbol2, .symbol3)
                    
                    title
                        .foregroundStyle(.textNormal)
                }
                .padding(10)
                .frame(width: geomentry.size.width)
                
            })
            
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.buttonBackground)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.buttonBorder, lineWidth: 2.0)
                
            }
        }.frame(height: 50)
        
    }
}

#Preview {
    VStack {
        HStack {
            ButtonView(image: .init(systemName: "signature"),
                       title: .init("signin")) {
                print("signin")
                
            }
            ButtonView(image: .init(systemName: "signature"),
                       title: .init("signin")) {
                print("signin")
                
            }
        }
        ButtonView(image: .init(systemName: "signature"),
                   title: .init("signin")) {
            print("signin")
            
        }
    }.padding(10)
}
