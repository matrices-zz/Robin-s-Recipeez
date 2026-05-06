import Foundation
import CoreData

@objc(NutritionInfo)
public class NutritionInfo: NSManagedObject {
    @NSManaged public var calories: Double
    @NSManaged public var protein: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
}
