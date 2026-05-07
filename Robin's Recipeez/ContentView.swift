//
//  ContentView.swift
//  Robin's Recipeez
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @State private var isShowingAddRecipe = false

    var body: some View {
        NavigationSplitView {
            ZStack {
                ItalianPatternBackground()
                    .ignoresSafeArea()

                if recipes.isEmpty {
                    EmptyCookbookView {
                        isShowingAddRecipe = true
                    }
                    .padding(28)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 18) {
                            CookbookHeader(recipeCount: recipes.count)

                            LazyVStack(spacing: 14) {
                                ForEach(recipes) { recipe in
                                    NavigationLink {
                                        RecipeDetailScreen(recipe: recipe)
                                    } label: {
                                        RecipeCard(recipe: recipe)
                                    }
                                    .buttonStyle(.plain)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            deleteRecipe(recipe)
                                        } label: {
                                            Label("Delete Recipe", systemImage: "trash")
                                        }
                                    }
                                }
                            }

                            Text("Build marker: Italian Trattoria Theme v1")
                                .font(.caption)
                                .foregroundStyle(RecipeTheme.cocoa.opacity(0.55))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 6)
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle("Robin’s Recipeez")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddRecipe = true
                    } label: {
                        Label("Add Recipe", systemImage: "plus")
                    }
                    .tint(RecipeTheme.tomato)
                }
            }
            .sheet(isPresented: $isShowingAddRecipe) {
                AddRecipeView()
            }
        } detail: {
            ZStack {
                ItalianPatternBackground()
                    .ignoresSafeArea()
                VStack(spacing: 14) {
                    TomatoCluster()
                        .frame(width: 128, height: 104)
                    Text("Pick a recipe")
                        .font(.title2.bold())
                        .foregroundStyle(RecipeTheme.ink)
                    Text("Tomatoes, basil, family notes — the good stuff opens here.")
                        .foregroundStyle(RecipeTheme.cocoa)
                }
            }
        }
    }

    private func deleteRecipe(_ recipe: Recipe) {
        withAnimation {
            modelContext.delete(recipe)
            try? modelContext.save()
        }
    }
}

private struct CookbookHeader: View {
    let recipeCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Robin’s Recipeez")
                        .font(.system(.largeTitle, design: .serif).weight(.bold))
                        .foregroundStyle(RecipeTheme.ink)
                    Text("Family Italian flavor, weeknight keepers, and the dishes worth writing down.")
                        .font(.subheadline)
                        .foregroundStyle(RecipeTheme.cocoa)
                }
                Spacer()
                TomatoCluster()
                    .frame(width: 92, height: 72)
            }

            VineDivider()

            HStack(spacing: 10) {
                StatPill(icon: "book.pages", text: "\(recipeCount) saved")
                StatPill(icon: "leaf.fill", text: "trattoria style")
            }
        }
        .padding(18)
        .background(RecipeTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: RecipeTheme.cocoa.opacity(0.14), radius: 16, x: 0, y: 8)
    }
}

private struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(recipe.isDessert ? RecipeTheme.butter.opacity(0.85) : RecipeTheme.sage.opacity(0.85))
                Image(systemName: recipe.isDessert ? "birthday.cake.fill" : "fork.knife")
                    .font(.title2)
                    .foregroundStyle(.white)
            }
            .frame(width: 58, height: 58)

            VStack(alignment: .leading, spacing: 7) {
                Text(recipe.title)
                    .font(.title3.bold())
                    .foregroundStyle(RecipeTheme.ink)
                    .lineLimit(2)

                Text(summaryLine(for: recipe))
                    .font(.subheadline)
                    .foregroundStyle(RecipeTheme.cocoa)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    MiniTag(icon: "person.2", text: "\(recipe.servings)")
                    if recipe.caloriesPerServing > 0 {
                        MiniTag(icon: "flame", text: "\(Int(recipe.caloriesPerServing)) cal")
                    }
                    MiniTag(icon: "list.bullet", text: "\(recipe.ingredients.count) ingredients")
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(RecipeTheme.tomato.opacity(0.75))
        }
        .padding(16)
        .background(RecipeTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(alignment: .topTrailing) {
            HStack(spacing: 3) {
                Image(systemName: "leaf.fill")
                    .foregroundStyle(RecipeTheme.basil)
                Image(systemName: "circle.fill")
                    .font(.system(size: 7))
                    .foregroundStyle(RecipeTheme.tomato)
            }
            .padding(14)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(RecipeTheme.basil.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: RecipeTheme.cocoa.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}

private struct EmptyCookbookView: View {
    let addRecipe: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(RecipeTheme.butter.opacity(0.55))
                    .frame(width: 140, height: 140)
                TomatoCluster()
                    .frame(width: 116, height: 94)
            }

            VStack(spacing: 8) {
                Text("Robin’s cookbook starts here")
                    .font(.system(.largeTitle, design: .serif).weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(RecipeTheme.ink)
                Text("Add the recipes she actually reaches for — dinners, desserts, little notes, and all the family tweaks that never make it into normal recipe apps.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(RecipeTheme.cocoa)
            }

            Button(action: addRecipe) {
                Label("Add the first recipe", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(RecipeTheme.tomato)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .padding(28)
        .background(RecipeTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: RecipeTheme.cocoa.opacity(0.16), radius: 20, x: 0, y: 10)
    }
}

private struct RecipeDetailScreen: View {
    let recipe: Recipe

    var body: some View {
        ZStack {
            ItalianPatternBackground()
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(recipe.isDessert ? "Sweet Treat" : "Kitchen Favorite")
                                .font(.caption.bold())
                                .textCase(.uppercase)
                                .tracking(1.2)
                                .foregroundStyle(RecipeTheme.tomato)
                            Spacer()
                            TomatoCluster()
                                .frame(width: 66, height: 50)
                        }

                        Text(recipe.title)
                            .font(.system(.largeTitle, design: .serif).weight(.bold))
                            .foregroundStyle(RecipeTheme.ink)

                        Text(summaryLine(for: recipe))
                            .font(.headline)
                            .foregroundStyle(RecipeTheme.cocoa)
                    }
                    .padding(22)
                    .background(RecipeTheme.card)
                    .overlay(alignment: .bottom) {
                        VineDivider()
                            .padding(.horizontal, 18)
                            .offset(y: -10)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))

                    HStack(spacing: 10) {
                        InfoTile(icon: "person.2.fill", title: "Serves", value: "\(recipe.servings)")
                        InfoTile(icon: "flame.fill", title: "Calories", value: recipe.caloriesPerServing > 0 ? "\(Int(recipe.caloriesPerServing))" : "—")
                        InfoTile(icon: "list.bullet.clipboard.fill", title: "Items", value: "\(recipe.ingredients.count)")
                    }

                    if !recipe.ingredients.isEmpty {
                        DetailBlock(title: "Ingredients", icon: "basket.fill") {
                            ForEach(recipe.ingredients) { ingredient in
                                HStack(alignment: .firstTextBaseline) {
                                    Text("•")
                                        .foregroundStyle(RecipeTheme.tomato)
                                    Text("\(ingredient.amount.formatted()) \(ingredient.unit) \(ingredient.name)")
                                        .foregroundStyle(RecipeTheme.ink)
                                }
                            }
                        }
                    }

                    DetailBlock(title: "Instructions", icon: "text.book.closed.fill") {
                        Text(recipe.instructions)
                            .foregroundStyle(RecipeTheme.ink)
                            .lineSpacing(5)
                    }

                    if let nutrition = recipe.nutrition {
                        DetailBlock(title: "Nutrition", icon: "chart.bar.fill") {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                NutritionBadge(title: "Calories", value: "\(Int(nutrition.calories))")
                                NutritionBadge(title: "Protein", value: "\(Int(nutrition.protein))g")
                                NutritionBadge(title: "Carbs", value: "\(Int(nutrition.carbs))g")
                                NutritionBadge(title: "Fat", value: "\(Int(nutrition.fat))g")
                            }
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct DetailBlock<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.title2.bold())
                .foregroundStyle(RecipeTheme.ink)
            content
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RecipeTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: RecipeTheme.cocoa.opacity(0.10), radius: 10, x: 0, y: 5)
    }
}

private struct InfoTile: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(RecipeTheme.tomato)
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(RecipeTheme.ink)
            Text(title)
                .font(.caption)
                .foregroundStyle(RecipeTheme.cocoa)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(RecipeTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct StatPill: View {
    let icon: String
    let text: String

    var body: some View {
        Label(text, systemImage: icon)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(RecipeTheme.butter.opacity(0.35))
            .foregroundStyle(RecipeTheme.cocoa)
            .clipShape(Capsule())
    }
}

private struct MiniTag: View {
    let icon: String
    let text: String

    var body: some View {
        Label(text, systemImage: icon)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(RecipeTheme.cream)
            .foregroundStyle(RecipeTheme.cocoa)
            .clipShape(Capsule())
    }
}

private struct NutritionBadge: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption)
                .foregroundStyle(RecipeTheme.cocoa)
            Text(value)
                .font(.headline)
                .foregroundStyle(RecipeTheme.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(RecipeTheme.cream.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private func summaryLine(for recipe: Recipe) -> String {
    let parts = [recipe.cuisine, recipe.proteinType, recipe.carbType]
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
    return parts.isEmpty ? "Homemade favorite" : parts.joined(separator: " • ")
}

#Preview {
    ContentView()
        .modelContainer(for: [Recipe.self, Ingredient.self, NutritionInfo.self], inMemory: true)
}
