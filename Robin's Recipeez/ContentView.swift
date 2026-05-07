//
//  ContentView.swift
//  Robin's Recipeez
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Recipe.title) private var recipes: [Recipe]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeDetailScreen(recipe: recipe)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(recipe.title)
                                .font(.headline)
                            Text("\(recipe.cuisine) • \(recipe.servings) servings • \(Int(recipe.caloriesPerServing)) cal/serving")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteRecipes)
            }
            .navigationTitle("Robin’s Recipeez")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addDemoRecipe) {
                        Label("Add Demo Recipe", systemImage: "plus")
                    }
                }
            }
            .overlay {
                if recipes.isEmpty {
                    ContentUnavailableView(
                        "No recipes yet",
                        systemImage: "fork.knife.circle",
                        description: Text("Tap + to add a sample recipe and verify the app is working.")
                    )
                }
            }
            .onAppear(perform: seedSampleDataIfNeeded)
        } detail: {
            Text("Select a recipe")
                .foregroundStyle(.secondary)
        }
    }

    private func seedSampleDataIfNeeded() {
        guard recipes.isEmpty else { return }
        insertRecipe(
            title: "Spaghetti Carbonara",
            cuisine: "Italian",
            proteinType: "Pancetta",
            carbType: "Pasta",
            caloriesPerServing: 540,
            isDessert: false,
            servings: 4,
            instructions: "Boil spaghetti until al dente. Render pancetta. Toss pasta with eggs, cheese, pepper, and pancetta off heat until glossy.",
            ingredients: [
                Ingredient(name: "Spaghetti", amount: 400, unit: "g"),
                Ingredient(name: "Pancetta", amount: 150, unit: "g"),
                Ingredient(name: "Egg yolks", amount: 4, unit: ""),
                Ingredient(name: "Pecorino Romano", amount: 75, unit: "g")
            ],
            nutrition: NutritionInfo(calories: 540, protein: 24, carbs: 62, fat: 22)
        )
    }

    private func addDemoRecipe() {
        insertRecipe(
            title: "Lemon Garlic Chicken",
            cuisine: "American",
            proteinType: "Chicken",
            carbType: "Potatoes",
            caloriesPerServing: 430,
            isDessert: false,
            servings: 4,
            instructions: "Season chicken. Roast with potatoes, lemon, garlic, olive oil, and herbs until golden and cooked through.",
            ingredients: [
                Ingredient(name: "Chicken thighs", amount: 6, unit: "pieces"),
                Ingredient(name: "Baby potatoes", amount: 1.5, unit: "lb"),
                Ingredient(name: "Lemon", amount: 1, unit: ""),
                Ingredient(name: "Garlic cloves", amount: 5, unit: "")
            ],
            nutrition: NutritionInfo(calories: 430, protein: 36, carbs: 32, fat: 18)
        )
    }

    private func insertRecipe(
        title: String,
        cuisine: String,
        proteinType: String,
        carbType: String,
        caloriesPerServing: Double,
        isDessert: Bool,
        servings: Int,
        instructions: String,
        ingredients: [Ingredient],
        nutrition: NutritionInfo
    ) {
        withAnimation {
            let recipe = Recipe(
                title: title,
                cuisine: cuisine,
                proteinType: proteinType,
                carbType: carbType,
                caloriesPerServing: caloriesPerServing,
                isDessert: isDessert,
                servings: servings,
                instructions: instructions,
                ingredients: ingredients,
                nutrition: nutrition
            )
            modelContext.insert(recipe)
        }
    }

    private func deleteRecipes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(recipes[index])
            }
        }
    }
}

private struct RecipeDetailScreen: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.title)
                        .font(.largeTitle.bold())
                    Text("\(recipe.cuisine) • \(recipe.proteinType) • \(recipe.carbType)")
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

#Preview {
    ContentView()
        .modelContainer(for: [Recipe.self, Ingredient.self, NutritionInfo.self], inMemory: true)
}
