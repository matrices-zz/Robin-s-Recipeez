//
//  ItalianMotifs.swift
//  Robin's Recipeez
//

import SwiftUI

struct ItalianPatternBackground: View {
    var body: some View {
        ZStack {
            RecipeTheme.backgroundGradient

            Image("ItalianRecipePattern")
                .resizable()
                .scaledToFill()
                .opacity(0.20)
                .blendMode(.multiply)

            LinearGradient(
                colors: [Color.white.opacity(0.20), RecipeTheme.cream.opacity(0.55)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

struct ItalianHeroArt: View {
    var body: some View {
        Image("ItalianCookbookHero")
            .resizable()
            .scaledToFit()
            .shadow(color: RecipeTheme.cocoa.opacity(0.20), radius: 12, x: 0, y: 8)
    }
}

struct VineDivider: View {
    var body: some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(RecipeTheme.basil.opacity(0.35))
                .frame(height: 1)
            Image(systemName: "leaf.fill")
                .foregroundStyle(RecipeTheme.basil)
            Image(systemName: "circle.fill")
                .font(.system(size: 7))
                .foregroundStyle(RecipeTheme.tomato)
            Image(systemName: "leaf.fill")
                .foregroundStyle(RecipeTheme.basil)
                .rotationEffect(.degrees(180))
            Rectangle()
                .fill(RecipeTheme.basil.opacity(0.35))
                .frame(height: 1)
        }
    }
}
