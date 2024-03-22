//
//  KTextField.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/22/24.
//

import SwiftUI

struct KTextField: View {
    let title:LocalizedStringKey
    @Binding var text:String
    var body: some View {
        TextField(title, text: $text)
        .foregroundStyle(Color.textFiledForeground)
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
