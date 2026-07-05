import SwiftUI

@main
struct MSphereApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .ignoresSafeArea(.container, edges: [.leading, .trailing, .bottom])
                .background(.black)
        }
    }
}
