//
//  PrimaryButtonModifier.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 06/05/25.
//

import SwiftUICore


// A custom ViewModifier to apply a consistent primary button style across the app
struct PrimaryButtonModifier: ViewModifier {
    // Defines how the content will be modified when this modifier is applied
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

// An extension on View to make applying the PrimaryButtonModifier easy and reusable
extension View {
    /// Applies the primary button style defined in PrimaryButtonModifier
    /// Example usage:
    /// ```
    /// Button("Click Me", action: Your action here)
    ///     .primaryButtonStyle()
    /// ```
    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonModifier())
    }
}
