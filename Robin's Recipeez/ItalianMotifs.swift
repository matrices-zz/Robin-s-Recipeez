//
//  ItalianMotifs.swift
//  Robin's Recipeez
//

import SwiftUI

struct ItalianPatternBackground: View {
    var body: some View {
        ZStack {
            RecipeTheme.backgroundGradient

            VStack {
                HStack {
                    OliveBranch()
                        .frame(width: 120, height: 90)
                        .rotationEffect(.degrees(-18))
                        .opacity(0.45)
                    Spacer()
                    TomatoCluster()
                        .frame(width: 96, height: 78)
                        .opacity(0.55)
                }
                Spacer()
                HStack {
                    TomatoCluster()
                        .frame(width: 82, height: 66)
                        .opacity(0.35)
                    Spacer()
                    OliveBranch()
                        .frame(width: 138, height: 96)
                        .rotationEffect(.degrees(155))
                        .opacity(0.35)
                }
            }
            .padding(18)
        }
    }
}

struct TomatoCluster: View {
    var body: some View {
        ZStack {
            Tomato(x: -22, y: 8, size: 42)
            Tomato(x: 12, y: -4, size: 48)
            Tomato(x: 28, y: 24, size: 34)

            BasilLeaf()
                .fill(RecipeTheme.basil)
                .frame(width: 28, height: 16)
                .rotationEffect(.degrees(-26))
                .offset(x: 4, y: -34)
            BasilLeaf()
                .fill(RecipeTheme.basil.opacity(0.85))
                .frame(width: 24, height: 14)
                .rotationEffect(.degrees(28))
                .offset(x: 26, y: -28)
        }
    }
}

private struct Tomato: View {
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat

    var body: some View {
        ZStack(alignment: .top) {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.white.opacity(0.42), RecipeTheme.tomato, Color(red: 0.58, green: 0.08, blue: 0.05)],
                        center: .topLeading,
                        startRadius: 2,
                        endRadius: size
                    )
                )
                .overlay(Circle().stroke(Color.white.opacity(0.45), lineWidth: 1))
            Image(systemName: "leaf.fill")
                .font(.system(size: max(10, size * 0.24)))
                .foregroundStyle(RecipeTheme.basil)
                .offset(y: -3)
        }
        .frame(width: size, height: size)
        .offset(x: x, y: y)
    }
}

struct OliveBranch: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(RecipeTheme.basil.opacity(0.8))
                .frame(width: 5, height: 112)
                .rotationEffect(.degrees(28))

            ForEach(0..<6) { index in
                BasilLeaf()
                    .fill(index.isMultiple(of: 2) ? RecipeTheme.sage : RecipeTheme.basil.opacity(0.8))
                    .frame(width: 28, height: 14)
                    .rotationEffect(.degrees(index.isMultiple(of: 2) ? -28 : 205))
                    .offset(x: CGFloat(index.isMultiple(of: 2) ? -18 : 18), y: CGFloat(index * 16 - 42))
            }

            ForEach(0..<4) { index in
                Circle()
                    .fill(RecipeTheme.cocoa.opacity(0.9))
                    .frame(width: 9, height: 9)
                    .offset(x: CGFloat(index.isMultiple(of: 2) ? 11 : -11), y: CGFloat(index * 20 - 28))
            }
        }
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

struct BasilLeaf: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control: CGPoint(x: rect.maxX, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.midY))
        return path
    }
}
