//
//  PrimaryButtonModifier.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 06/05/25.
//

import SwiftUICore


struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(4)
            .shadow(radius: 5)
    }
}

extension View {
    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonModifier())
    }
}
