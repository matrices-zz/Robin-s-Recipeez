//
//  RecipeTheme.swift
//  Robin's Recipeez
//

import SwiftUI

enum RecipeTheme {
    static let cream = Color(red: 0.99, green: 0.94, blue: 0.84)
    static let butter = Color(red: 1.00, green: 0.82, blue: 0.35)
    static let tomato = Color(red: 0.84, green: 0.26, blue: 0.20)
    static let basil = Color(red: 0.22, green: 0.47, blue: 0.29)
    static let sage = Color(red: 0.58, green: 0.67, blue: 0.47)
    static let ink = Color(red: 0.22, green: 0.15, blue: 0.10)
    static let cocoa = Color(red: 0.41, green: 0.25, blue: 0.16)
    static let card = Color.white.opacity(0.88)

    static let backgroundGradient = LinearGradient(
        colors: [cream, Color(red: 1.00, green: 0.89, blue: 0.73)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
