//
//  KNumberSelect.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/29/24.
//

import SwiftUI

struct KNumberSelect: View {
    let label:Text
    @Binding var select:Int
    var body: some View {
        HStack {
            label.font(.subheadline).foregroundStyle(.secondary)
            KButton(label: .init("-"), style: .secondary) { on in
                if on {
                    select -= 1;
                }
            }
            Text("\(select)")
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.textFiledBackground)
                }
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.textFiledForeground,lineWidth: 2.0)
                }
                .foregroundColor(.textFiledForeground)
            
            KButton(label: .init("+"), style: .secondary) { on in
                if on {
                    select += 1;
                }
            }

        }
    }
}

#Preview {
    KNumberSelect(label:.init("test"), select: .constant(10))
}
