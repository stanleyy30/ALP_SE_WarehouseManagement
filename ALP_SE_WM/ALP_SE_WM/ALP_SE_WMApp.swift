import SwiftUI
import Firebase

@main
struct ALP_SE_WMApp: App {
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            InventoryListView()
        }
    }
}
