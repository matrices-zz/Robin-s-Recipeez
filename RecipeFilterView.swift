import SwiftUI

struct RecipeFilterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedProtein = "All"
    @State private var selectedCarb = "All"
    @State private var selectedCuisine = "All"
    @State private var maxCalories = 800.0
    
    let proteins = ["All","Beef","Chicken","Fish","Veggie"]
    let carbs = ["All","Rice","Beans","Pasta","Potato","None"]
    let cuisines = ["All","Italian","Spanish","German","French","Asian","Other"]
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Protein", selection: $selectedProtein) {
                    ForEach(proteins, id: \ .self) { Text($0) }
                }
                Picker("Carb", selection: $selectedCarb) {
                    ForEach(carbs, id: \ .self) { Text($0) }
                }
                Picker("Cuisine", selection: $selectedCuisine) {
                    ForEach(cuisines, id: \ .self) { Text($0) }
                }
                VStack(alignment: .leading) {
                    Text("Max calories per serving: \(Int(maxCalories))")
                    Slider(value: $maxCalories, in: 0...2000, step: 10)
                }
            }
            .navigationTitle("Filter Recipes")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        applyFilter()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func applyFilter() {
        var predicates: [NSPredicate] = []
        if selectedProtein != "All" {
            predicates.append(NSPredicate(format: "proteinType == %@", selectedProtein.lowercased()))
        }
        if selectedCarb != "All" {
            predicates.append(NSPredicate(format: "carbType == %@", selectedCarb.lowercased()))
        }
        if selectedCuisine != "All" {
            predicates.append(NSPredicate(format: "cuisine == %@", selectedCuisine))
        }
        predicates.append(NSPredicate(format: "caloriesPerServing <= %f", maxCalories))
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        NotificationCenter.default.post(name: .recipeFilterChanged, object: compound)
    }
}
