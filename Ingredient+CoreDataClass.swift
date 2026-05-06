import Foundation
import CoreData

@objc(Ingredient)
public class Ingredient: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var amount: Double
    @NSManaged public var unit: String
    @NSManaged public var recipe: Recipe
    @NSManaged public var nutrition: NutritionInfo?
}
