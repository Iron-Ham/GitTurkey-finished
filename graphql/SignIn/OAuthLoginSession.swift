import Foundation

struct OAuthLoginSession {
    typealias OAuthState = String
    typealias OAuthToken = String

    enum OAuthError: Error {
        case invalidURL
        case invalidScheme
        case missingState
        case invalidState
        case missingOAuthToken
    }

    private let state: OAuthState

    private static func generateRandomState() -> OAuthState {
        UUID().uuidString
    }

    init(state: OAuthState = generateRandomState()) {
        self.state = state
    }

    var loginURL: URL {
        guard let url = URLBuilder.github()
            .add(paths: ["login", "oauth", "authorize"])
            .add(item: "client_id", value: GITHUB_CLIENT_ID)
            .add(item: "scope", value: LoginScopes.allRequired)
            .add(item: "state", value: state)
            .add(item: "allow_signup", value: "false")
            .url
            else { fatalError("Failed to create login URL") }
        return url
    }

    func parse(callbackUrl url: URL) throws -> OAuthToken {
        guard url.scheme == "demo" else {
            throw OAuthError.invalidScheme
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw OAuthError.invalidURL
        }

        guard let state = components.queryItems?.first(where: { $0.name == "state" })?.value else {
            throw OAuthError.missingState
        }

        // Ensure callback state matches the OAuth state our app generated.
        // @seealso: https://github.com/github/pe-mobile-ios/issues/1890
        guard state == self.state else {
            throw OAuthError.invalidState
        }

        guard let token = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            throw OAuthError.missingOAuthToken
        }

        return token
    }

    func parse(callback: (URL?, Error?)) throws -> OAuthToken {
        if let error = callback.1 {
            throw error
        }

        guard let url = callback.0 else {
            throw OAuthError.invalidURL
        }

        return try parse(callbackUrl: url)
    }
}
