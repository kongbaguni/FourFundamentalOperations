//
//  KTextField.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/22/24.
//

import SwiftUI

struct KTextField: View {
    let title:Text
    @Binding var text:String
    
    var textFieldView : some View {
        if #available(iOS 17.0, *) {
            TextField(text: $text, prompt: title.foregroundStyle(Color.textFiledPlaceholder)) {
                title
            }
        }
        else {
            TextField(
                text: $text,
                prompt: title.foregroundColor(.textFiledPlaceholder)) {
                title
            }
        }
    }
    
    var body: some View {
        textFieldView
            .foregroundStyle(Color.textFiledForeground)
            .accentColor(.yellow)
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.textFiledBackground)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.textFiledForeground, lineWidth: 2)
            }
            .padding(.bottom, 10)
       
    }
}

#Preview {
    VStack {
        KTextField(title: .init("test123"), text: .constant(""))
        KTextField(title: .init("test123"), text: .constant("test"))
    }
}
