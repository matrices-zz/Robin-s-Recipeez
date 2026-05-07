//
//  ContentView.swift
//  Robin's Recipeez
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @State private var isShowingAddRecipe = false

    var body: some View {
        NavigationSplitView {
            List {
                Section {
                    ForEach(recipes) { recipe in
                        NavigationLink {
                            RecipeDetailScreen(recipe: recipe)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(recipe.title)
                                    .font(.headline)
                                Text("\(displayText(recipe.cuisine, fallback: "Cuisine")) • \(recipe.servings) servings • \(Int(recipe.caloriesPerServing)) cal/serving")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteRecipes)
                } footer: {
                    Text("Build marker: Add Recipe Form v2 — no automatic sample recipes")
                }
            }
            .navigationTitle("Robin’s Recipeez")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddRecipe = true
                    } label: {
                        Label("Add Recipe", systemImage: "plus")
                    }
                }
            }
            .overlay {
                if recipes.isEmpty {
                    ContentUnavailableView(
                        "No recipes yet",
                        systemImage: "fork.knife.circle",
                        description: Text("Tap + to add Robin’s first recipe.")
                    )
                }
            }
            .sheet(isPresented: $isShowingAddRecipe) {
                AddRecipeView()
            }
        } detail: {
            Text("Select a recipe")
                .foregroundStyle(.secondary)
        }
    }

    private func deleteRecipes(offsets: IndexSet) {
        // In sorted @Query order, this deletes the visible rows the user swiped.
        for index in offsets {
            modelContext.delete(recipes[index])
        }
        try? modelContext.save()
    }

    @Environment(\.modelContext) private var modelContext
}

private struct RecipeDetailScreen: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.title)
                        .font(.largeTitle.bold())
                    Text("\(displayText(recipe.cuisine, fallback: "Cuisine")) • \(displayText(recipe.proteinType, fallback: "Protein")) • \(displayText(recipe.carbType, fallback: "Carb/side"))")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 18) {
                    Label("\(recipe.servings) servings", systemImage: "person.2")
                    Label("\(Int(recipe.caloriesPerServing)) cal", systemImage: "flame")
                }
                .font(.subheadline)

                if !recipe.ingredients.isEmpty {
                    SectionBlock(title: "Ingredients") {
                        ForEach(recipe.ingredients) { ingredient in
                            Text("• \(ingredient.amount.formatted()) \(ingredient.unit) \(ingredient.name)")
                        }
                    }
                }

                SectionBlock(title: "Instructions") {
                    Text(recipe.instructions)
                }

                if let nutrition = recipe.nutrition {
                    SectionBlock(title: "Nutrition") {
                        Text("Calories: \(Int(nutrition.calories))")
                        Text("Protein: \(Int(nutrition.protein))g")
                        Text("Carbs: \(Int(nutrition.carbs))g")
                        Text("Fat: \(Int(nutrition.fat))g")
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct SectionBlock<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2.bold())
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private func displayText(_ value: String, fallback: String) -> String {
    let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.isEmpty ? fallback : trimmed
}

#Preview {
    ContentView()
        .modelContainer(for: [Recipe.self, Ingredient.self, NutritionInfo.self], inMemory: true)
}
