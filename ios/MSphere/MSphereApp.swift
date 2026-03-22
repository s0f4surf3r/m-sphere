import SwiftUI

@main
struct MSphereApp: App {
    @StateObject private var storeManager = StoreManager()

    var body: some Scene {
        WindowGroup {
            ContentView(storeManager: storeManager)
                .ignoresSafeArea(.container, edges: [.leading, .trailing, .bottom])
                .background(.black)
        }
    }
}
