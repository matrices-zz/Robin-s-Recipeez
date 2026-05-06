import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Image (if any)
            if let path = recipe.imagePath,
               let uiImg = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImg)
                    .resizable()
                    .scaledToFit()
            }
            
            Text(recipe.title)
                .font(.largeTitle)
                .bold()
            
            // Basic metadata
            HStack {
                Text("Cuisine: \(recipe.cuisine)")
                Spacer()
                Text("Protein: \(recipe.proteinType)")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            // Ingredients list
            Text("Ingredients")
                .font(.headline)
            ForEach(Array(recipe.ingredients), id: \ .self) { ingredient in
                Text("• \(ingredient.amount) \(ingredient.unit) \(ingredient.name)")
            }
            
            // Steps
            Text("Directions")
                .font(.headline)
            ForEach(recipe.steps.array as! [String], id: \ .self) { step in
                Text(step)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(recipe.title)
    }
}

// Helper to convert NSOrderedSet of steps to [String]
extension NSOrderedSet {
    var array: [Any] { return self.map { $0 } }
}
