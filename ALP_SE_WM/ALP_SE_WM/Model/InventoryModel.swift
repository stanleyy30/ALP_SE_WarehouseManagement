import Foundation
import FirebaseFirestore

struct InventoryItem: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var quantity: Int
    var entryDate: Date
    var exitDate: Date?
    var category: String
}
