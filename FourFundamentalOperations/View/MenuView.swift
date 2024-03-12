//
//  MenuView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/6/24.
//

import Foundation
import SwiftUI

struct MenuView : View {
    var body: some View {
        VStack {
            ButtonView(
                image: .init(systemName: "apple.logo"),
                title: .init("Sign in with Apple"),
                style: .secondary) {
            }
            ButtonView(
                image: .init("GoogleLogo"),
                title: .init("Sign in with Google"),
                style: .secondary) {
                    
                }
            
        }.padding()
    }
}

#Preview {
    MenuView()
}
