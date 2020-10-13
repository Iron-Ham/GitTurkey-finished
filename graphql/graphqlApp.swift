import SwiftUI

@main
struct graphqlApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { (url) in
                    print(url)
                }
        }
    }
}
