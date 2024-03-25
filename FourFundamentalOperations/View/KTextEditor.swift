//
//  KTextEdit.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/25/24.
//

import SwiftUI

struct KTextEditor: View {
    @Binding var text:String
    var body: some View {
        TextEditor(text: $text)
            .frame(minHeight: 60)
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
            .scrollContentBackground(.hidden)
    }
}

#Preview {
    ScrollView {
        KTextEditor(text: .constant("""
djskaldjl
dsajkld
dsjakl
dsjakl
djkasl
"""))
    }
}
