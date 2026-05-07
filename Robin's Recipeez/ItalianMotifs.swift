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
                .opacity(0.13)
                .blendMode(.multiply)

            LinearGradient(
                colors: [Color.white.opacity(0.18), RecipeTheme.cream.opacity(0.62)],
                startPoint: .top,
                endPoint: .bottom
            )

            VineyardEdgeFrame()
                .padding(8)
                .opacity(0.92)
        }
    }
}

struct ItalianHeroArt: View {
    var body: some View {
        ZStack {
            OliveBranch()
                .frame(width: 116, height: 92)
                .rotationEffect(.degrees(-32))
                .offset(x: -8, y: 4)
            TomatoCluster()
                .frame(width: 92, height: 76)
                .offset(x: 18, y: -2)
        }
    }
}

struct VineyardEdgeFrame: View {
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height

            ZStack {
                CornerVine()
                    .frame(width: 180, height: 160)
                    .position(x: 74, y: 72)

                CornerVine()
                    .frame(width: 180, height: 160)
                    .rotationEffect(.degrees(90))
                    .position(x: width - 74, y: 72)

                CornerVine()
                    .frame(width: 180, height: 160)
                    .rotationEffect(.degrees(270))
                    .position(x: 74, y: height - 72)

                CornerVine()
                    .frame(width: 180, height: 160)
                    .rotationEffect(.degrees(180))
                    .position(x: width - 74, y: height - 72)

                EdgeLeafRun()
                    .frame(width: max(width - 210, 80), height: 32)
                    .position(x: width / 2, y: 20)

                EdgeLeafRun()
                    .frame(width: max(width - 210, 80), height: 32)
                    .rotationEffect(.degrees(180))
                    .position(x: width / 2, y: height - 20)
            }
        }
        .allowsHitTesting(false)
    }
}

private struct CornerVine: View {
    var body: some View {
        ZStack {
            ArcStem()
                .stroke(RecipeTheme.basil.opacity(0.58), style: StrokeStyle(lineWidth: 4, lineCap: .round))

            ForEach(0..<7) { index in
                BasilLeaf()
                    .fill(index.isMultiple(of: 2) ? RecipeTheme.basil.opacity(0.76) : RecipeTheme.sage.opacity(0.80))
                    .frame(width: 34, height: 18)
                    .rotationEffect(.degrees(index.isMultiple(of: 2) ? -28 : 38))
                    .offset(x: CGFloat(index * 18 - 58), y: CGFloat(index.isMultiple(of: 2) ? -34 + index * 7 : -14 + index * 5))
            }

            Circle()
                .fill(RecipeTheme.tomato)
                .frame(width: 26, height: 26)
                .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 1))
                .offset(x: 56, y: 16)
            Circle()
                .fill(RecipeTheme.tomato.opacity(0.88))
                .frame(width: 18, height: 18)
                .offset(x: 76, y: 34)
        }
    }
}

private struct EdgeLeafRun: View {
    var body: some View {
        HStack(spacing: 14) {
            ForEach(0..<9) { index in
                Group {
                    if index.isMultiple(of: 3) {
                        Circle()
                            .fill(RecipeTheme.tomato.opacity(0.72))
                            .frame(width: 8, height: 8)
                    } else {
                        BasilLeaf()
                            .fill(index.isMultiple(of: 2) ? RecipeTheme.basil.opacity(0.62) : RecipeTheme.sage.opacity(0.70))
                            .frame(width: 22, height: 11)
                            .rotationEffect(.degrees(index.isMultiple(of: 2) ? 24 : -24))
                    }
                }
            }
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
                    .fill(RecipeTheme.olive.opacity(0.92))
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

private struct ArcStem: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + 18, y: rect.maxY - 16))
        path.addCurve(
            to: CGPoint(x: rect.maxX - 20, y: rect.minY + 20),
            control1: CGPoint(x: rect.minX + 42, y: rect.midY),
            control2: CGPoint(x: rect.midX + 24, y: rect.minY + 2)
        )
        return path
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
