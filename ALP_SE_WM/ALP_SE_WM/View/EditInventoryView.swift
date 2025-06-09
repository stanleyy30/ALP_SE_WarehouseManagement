import SwiftUI
import FirebaseFirestore

struct EditInventoryItemView: View {
    @ObservedObject var viewModel: InventoryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var item: InventoryItem
    
    @State private var name: String
    @State private var quantity: Int
    @State private var category: String
    @State private var entryDate: Date
    @State private var exitDateEnabled: Bool
    @State private var exitDate: Date
    
    @State private var showQuantityDialog = false
    
    init(viewModel: InventoryViewModel, item: InventoryItem) {
        self.viewModel = viewModel
        self.item = item
        _name = State(initialValue: item.name)
        _quantity = State(initialValue: item.quantity)
        _category = State(initialValue: item.category)
        _entryDate = State(initialValue: item.entryDate)
        _exitDateEnabled = State(initialValue: item.exitDate != nil)
        _exitDate = State(initialValue: item.exitDate ?? Date())
    }
    
    var body: some View {
        Form {
            Section(header: Text("Edit Item")) {
                TextField("Item Name", text: $name)
                
                Button {
                    showQuantityDialog = true
                } label: {
                    HStack {
                        Text("Quantity")
                        Spacer()
                        Text("\(quantity)")
                            .foregroundColor(.gray)
                    }
                }
                
                TextField("Category", text: $category)
                DatePicker("Entry Date", selection: $entryDate, displayedComponents: .date)
                
                Toggle("Has Exit Date", isOn: $exitDateEnabled)
                if exitDateEnabled {
                    DatePicker("Exit Date", selection: $exitDate, displayedComponents: .date)
                }
            }
            
            Button("Update Item") {
                let updatedItem = InventoryItem(
                    id: item.id,
                    name: name,
                    quantity: quantity,
                    entryDate: entryDate,
                    exitDate: exitDateEnabled ? exitDate : nil,
                    category: category
                )
                viewModel.updateItem(updatedItem)
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Edit Inventory")
        .confirmationDialog("Select Quantity", isPresented: $showQuantityDialog) {
            ForEach(1...30, id: \.self) { number in
                Button("\(number)") {
                    quantity = number
                }
            }
        }
    }
}

#Preview {
    let viewModel = InventoryViewModel()
    let item = InventoryItem(id: "123", name: "Sample", quantity: 5, entryDate: Date(), exitDate: nil, category: "Food")
    return EditInventoryItemView(viewModel: viewModel, item: item)
}
