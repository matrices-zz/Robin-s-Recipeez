import SwiftUI
import CoreData

struct RecipeListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Recipe.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.title, ascending: true)],
        animation: .default
    ) private var recipes: FetchedResults<Recipe>
    
    @State private var showingFilterSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recipes, id: \ .self) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        HStack {
                            if let path = recipe.imagePath,
                               let uiImg = UIImage(contentsOfFile: path) {
                                Image(uiImage: uiImg)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                            VStack(alignment: .leading) {
                                Text(recipe.title)
                                    .font(.headline)
                                Text("\(recipe.cuisine) • \(recipe.proteinType.capitalized)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Robin's Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingFilterSheet.toggle()
                    } label: {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingFilterSheet) {
                RecipeFilterView()
            }
        }
    }
}
