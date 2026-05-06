import Foundation
import CoreData

@objc(Recipe)
public class Recipe: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var cuisine: String
    @NSManaged public var proteinType: String
    @NSManaged public var carbType: String
    @NSManaged public var caloriesPerServing: Double
    @NSManaged public var isDessert: Bool
    @NSManaged public var servings: Int16
    @NSManaged public var imagePath: String?
    @NSManaged public var sourceURL: String?
    @NSManaged public var ingredients: Set<Ingredient>
    @NSManaged public var steps: NSOrderedSet // ordered list of step strings
}

// MARK: - Generated accessors for ingredients
extension Recipe {
    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)
    
    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)
    
    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)
    
    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)
}
