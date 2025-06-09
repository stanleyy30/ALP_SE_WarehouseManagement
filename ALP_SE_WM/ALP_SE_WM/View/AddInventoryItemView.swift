import SwiftUI

struct AddInventoryItemView: View {
    @ObservedObject var viewModel: InventoryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var quantity = 1
    @State private var category = ""
    @State private var entryDate = Date()
    @State private var exitDate = Date()
    
    @State private var showQuantityDialog = false
    
    var body: some View {
        Form {
            Section(header: Text("Item Information")) {
                TextField("Item Name", text: $name)

                // Quantity selector as button
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
                DatePicker("Exit Date", selection: $exitDate, displayedComponents: .date)
            }
            
            Button("Save Item") {
                let newItem = InventoryItem(
                    name: name,
                    quantity: quantity,
                    entryDate: entryDate,
                    exitDate: exitDate,
                    category: category
                )
                viewModel.addItem(newItem) { success in
                    if success {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationTitle("Add Inventory")
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
    AddInventoryItemView(viewModel: InventoryViewModel())
}
