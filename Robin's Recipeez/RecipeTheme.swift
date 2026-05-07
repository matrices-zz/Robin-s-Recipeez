//
//  RecipeTheme.swift
//  Robin's Recipeez
//

import SwiftUI

enum RecipeTheme {
    static let cream = Color(red: 1.00, green: 0.95, blue: 0.84)
    static let butter = Color(red: 1.00, green: 0.82, blue: 0.35)
    static let tomato = Color(red: 0.80, green: 0.12, blue: 0.09)
    static let basil = Color(red: 0.13, green: 0.40, blue: 0.20)
    static let sage = Color(red: 0.57, green: 0.67, blue: 0.45)
    static let olive = Color(red: 0.33, green: 0.36, blue: 0.16)
    static let ink = Color(red: 0.20, green: 0.11, blue: 0.07)
    static let cocoa = Color(red: 0.41, green: 0.25, blue: 0.16)
    static let pasta = Color(red: 0.96, green: 0.75, blue: 0.38)
    static let card = Color.white.opacity(0.90)

    static let backgroundGradient = LinearGradient(
        colors: [cream, Color(red: 1.00, green: 0.89, blue: 0.70), Color(red: 0.96, green: 0.80, blue: 0.62)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
