//
//  RecipeModels.swift
//  Robin's Recipeez
//

import Foundation
import SwiftData

@Model
final class Recipe {
    var id: UUID
    var title: String
    var cuisine: String
    var proteinType: String
    var carbType: String
    var caloriesPerServing: Double
    var isDessert: Bool
    var servings: Int
    var instructions: String

    @Relationship(deleteRule: .cascade)
    var ingredients: [Ingredient]

    @Relationship(deleteRule: .cascade)
    var nutrition: NutritionInfo?

    init(
        id: UUID = UUID(),
        title: String,
        cuisine: String,
        proteinType: String,
        carbType: String,
        caloriesPerServing: Double,
        isDessert: Bool,
        servings: Int,
        instructions: String,
        ingredients: [Ingredient] = [],
        nutrition: NutritionInfo? = nil
    ) {
        self.id = id
        self.title = title
        self.cuisine = cuisine
        self.proteinType = proteinType
        self.carbType = carbType
        self.caloriesPerServing = caloriesPerServing
        self.isDessert = isDessert
        self.servings = servings
        self.instructions = instructions
        self.ingredients = ingredients
        self.nutrition = nutrition
    }
}

@Model
final class Ingredient {
    var name: String
    var amount: Double
    var unit: String

    init(name: String, amount: Double, unit: String) {
        self.name = name
        self.amount = amount
        self.unit = unit
    }
}

@Model
final class NutritionInfo {
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double

    init(calories: Double, protein: Double, carbs: Double, fat: Double) {
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }
}
