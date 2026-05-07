//
//  AddRecipeView.swift
//  Robin's Recipeez
//

import SwiftUI
import SwiftData

struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var cuisine = ""
    @State private var proteinType = ""
    @State private var carbType = ""
    @State private var servings = 4
    @State private var caloriesPerServing = ""
    @State private var isDessert = false
    @State private var instructions = ""
    @State private var ingredients: [IngredientDraft] = [IngredientDraft()]

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !instructions.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ItalianPatternBackground()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .center, spacing: 14) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("New Recipe")
                                    .font(.system(.largeTitle, design: .serif).weight(.bold))
                                    .foregroundStyle(RecipeTheme.ink)
                                Text("Capture the dish, the details, and the little notes that make it Robin’s.")
                                    .foregroundStyle(RecipeTheme.cocoa)
                            }
                            Spacer()
                            TomatoCluster()
                                .frame(width: 82, height: 64)
                        }
                        .padding(.horizontal, 4)

                        FormCard(title: "Recipe", icon: "book.closed.fill") {
                            TextField("Title", text: $title)
                                .textInputAutocapitalization(.words)
                            TextField("Cuisine", text: $cuisine)
                                .textInputAutocapitalization(.words)
                            TextField("Protein", text: $proteinType)
                                .textInputAutocapitalization(.words)
                            TextField("Carb / side", text: $carbType)
                                .textInputAutocapitalization(.words)
                            Stepper("Servings: \(servings)", value: $servings, in: 1...24)
                            TextField("Calories per serving", text: $caloriesPerServing)
                                .keyboardType(.decimalPad)
                            Toggle("Dessert", isOn: $isDessert)
                        }

                        FormCard(title: "Ingredients", icon: "basket.fill") {
                            ForEach($ingredients) { $ingredient in
                                VStack(alignment: .leading, spacing: 8) {
                                    TextField("Ingredient", text: $ingredient.name)
                                        .textInputAutocapitalization(.words)
                                    HStack {
                                        TextField("Amount", text: $ingredient.amount)
                                            .keyboardType(.decimalPad)
                                        TextField("Unit", text: $ingredient.unit)
                                            .textInputAutocapitalization(.never)
                                    }
                                }
                                .padding(12)
                                .background(RecipeTheme.cream.opacity(0.7))
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }

                            Button {
                                ingredients.append(IngredientDraft())
                            } label: {
                                Label("Add Ingredient", systemImage: "plus.circle.fill")
                                    .font(.headline)
                            }
                            .tint(RecipeTheme.tomato)
                        }

                        FormCard(title: "Instructions", icon: "text.book.closed.fill") {
                            TextEditor(text: $instructions)
                                .frame(minHeight: 170)
                                .scrollContentBackground(.hidden)
                                .padding(10)
                                .background(RecipeTheme.cream.opacity(0.7))
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Add Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(RecipeTheme.cocoa)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveRecipe)
                        .disabled(!canSave)
                        .tint(RecipeTheme.tomato)
                }
            }
        }
    }

    private func saveRecipe() {
        let cleanedIngredients = ingredients
            .map { draft in
                Ingredient(
                    name: draft.name.trimmingCharacters(in: .whitespacesAndNewlines),
                    amount: Double(draft.amount) ?? 0,
                    unit: draft.unit.trimmingCharacters(in: .whitespacesAndNewlines)
                )
            }
            .filter { !$0.name.isEmpty }

        let nutrition = NutritionInfo(
            calories: Double(caloriesPerServing) ?? 0,
            protein: 0,
            carbs: 0,
            fat: 0
        )

        let recipe = Recipe(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            cuisine: cuisine.trimmingCharacters(in: .whitespacesAndNewlines),
            proteinType: proteinType.trimmingCharacters(in: .whitespacesAndNewlines),
            carbType: carbType.trimmingCharacters(in: .whitespacesAndNewlines),
            caloriesPerServing: Double(caloriesPerServing) ?? 0,
            isDessert: isDessert,
            servings: servings,
            instructions: instructions.trimmingCharacters(in: .whitespacesAndNewlines),
            ingredients: cleanedIngredients,
            nutrition: nutrition
        )

        modelContext.insert(recipe)
        try? modelContext.save()
        dismiss()
    }
}

private struct FormCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.title3.bold())
                    .foregroundStyle(RecipeTheme.ink)
                Spacer()
                Image(systemName: "leaf.fill")
                    .foregroundStyle(RecipeTheme.basil)
            }

            VineDivider()

            VStack(spacing: 12) {
                content
            }
        }
        .padding(18)
        .background(RecipeTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: RecipeTheme.cocoa.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}

private struct IngredientDraft: Identifiable {
    let id = UUID()
    var name = ""
    var amount = ""
    var unit = ""
}

#Preview {
    AddRecipeView()
        .modelContainer(for: [Recipe.self, Ingredient.self, NutritionInfo.self], inMemory: true)
}
