import SwiftUI

struct InventoryListView: View {
    @StateObject private var viewModel = InventoryViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name).bold()
                                Text("Quantity: \(item.quantity)")
                                Text("Category: \(item.category)")
                                Text("Entered: \(item.entryDate.formatted(date: .abbreviated, time: .omitted))")
                            }
                            Spacer()
                            NavigationLink(destination: EditInventoryItemView(viewModel: viewModel, item: item)) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { viewModel.deleteItem(viewModel.items[$0]) }
                }
            }
            .navigationTitle("Inventory")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Add", destination: AddInventoryItemView(viewModel: viewModel))
                }
            }
            .onAppear {
                viewModel.fetchItems()
            }
        }
    }
}

#Preview {
    InventoryListView()
}
