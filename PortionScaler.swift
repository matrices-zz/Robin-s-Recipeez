import Foundation

/// Utility to scale an ingredient amount based on target servings.
func scaledAmount(original amount: Double, originalServings: Int, targetServings: Int) -> Double {
    guard originalServings > 0 else { return amount }
    return amount * Double(targetServings) / Double(originalServings)
}
