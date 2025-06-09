import Foundation
import FirebaseFirestore

class InventoryViewModel: ObservableObject {
    @Published var items: [InventoryItem] = []
    
    private let db = Firestore.firestore()
    
    func fetchItems() {
        db.collection("inventory").order(by: "entryDate", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.items = documents.compactMap { try? $0.data(as: InventoryItem.self) }
            }
    }
    
    func addItem(_ item: InventoryItem, completion: @escaping (Bool) -> Void) {
        do {
            _ = try db.collection("inventory").addDocument(from: item)
            completion(true)
        } catch {
            print("Failed to add item: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func deleteItem(_ item: InventoryItem) {
        guard let id = item.id else { return }
        db.collection("inventory").document(id).delete()
    }
    
    func updateItem(_ item: InventoryItem) {
        guard let id = item.id else { return }
        do {
            try db.collection("inventory").document(id).setData(from: item)
        } catch {
            print("Failed to update item: \(error.localizedDescription)")
        }
    }
}
