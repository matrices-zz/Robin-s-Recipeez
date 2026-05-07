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
            Form {
                Section("Recipe") {
                    TextField("Title", text: $title)
                    TextField("Cuisine", text: $cuisine)
                    TextField("Protein", text: $proteinType)
                    TextField("Carb / side", text: $carbType)
                    Stepper("Servings: \(servings)", value: $servings, in: 1...24)
                    TextField("Calories per serving", text: $caloriesPerServing)
                        .keyboardType(.decimalPad)
                    Toggle("Dessert", isOn: $isDessert)
                }

                Section("Ingredients") {
                    ForEach($ingredients) { $ingredient in
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Ingredient", text: $ingredient.name)
                            HStack {
                                TextField("Amount", text: $ingredient.amount)
                                    .keyboardType(.decimalPad)
                                TextField("Unit", text: $ingredient.unit)
                            }
                        }
                    }
                    .onDelete { offsets in
                        ingredients.remove(atOffsets: offsets)
                        if ingredients.isEmpty {
                            ingredients.append(IngredientDraft())
                        }
                    }

                    Button {
                        ingredients.append(IngredientDraft())
                    } label: {
                        Label("Add Ingredient", systemImage: "plus.circle")
                    }
                }

                Section("Instructions") {
                    TextEditor(text: $instructions)
                        .frame(minHeight: 160)
                }
            }
            .navigationTitle("Add Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveRecipe)
                        .disabled(!canSave)
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
