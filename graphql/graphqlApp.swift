import SwiftUI

@main
struct graphqlApp: App {
    @ObservedObject var authService = OAuthService()
    var body: some Scene {
        WindowGroup {
            if authService.authToken == nil {
                ContentView().environmentObject(OAuthService())
                    .onOpenURL { (url) in
                        handleOpenUrl(
                            notificationName: .gitHubCallback,
                            callbackScheme: GITHUB_URL_SCHEME,
                            url: url
                        )
                    }
            } else {
                Text("Hi")
            }
        }
    }

    private func handleOpenUrl(
        notificationName: Notification.Name,
        callbackScheme scheme: String,
        url: URL?
    ) {
        guard let url = url,
              let urlScheme = url.scheme,
              let callbackUrl = URL(string: "\(scheme)://"),
              let callbackScheme = callbackUrl.scheme
        else { return }
        guard urlScheme.caseInsensitiveCompare(callbackScheme) == .orderedSame else { return }
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let urlComponents = urlComponents,
           let items = urlComponents.queryItems,
           let item = items.filter({ $0.name == "code" }).first, url.host == "auth" {
            authService.authCode = item.value
        }
        let notification = Notification(name: notificationName,object: url, userInfo: nil)
        NotificationCenter.default.post(notification)
    }



}
