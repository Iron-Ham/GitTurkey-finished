import AuthenticationServices
import Combine
import Foundation

class OAuthService: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {

    let objectWillChange = PassthroughSubject<OAuthService, Never>()
    private var session: ASWebAuthenticationSession?
    private var cancellable: AnyCancellable?

    @Published var authUrl = URL(
        string: "https://github.com/login/oauth/authorize?client_id=\(GITHUB_CLIENT_ID)&scope=user"
    )

    @Published var isLoggedIn: Bool = false {
        willSet { self.objectWillChange.send(self) }
    }

    var authCode: String?
    @Published var authToken: String? {
        willSet { self.objectWillChange.send(self) }
    }

    func onSignInButton() {
        /// Initiates a new ASWebAuthenticationSession, handling errors.
        func startSession() {
            let loginSession = OAuthLoginSession()
            let callbackScheme = "demo://"
            let callback: (URL?, Error?) -> Void = { [weak self] url, error in
                let result = Result {
                    try loginSession.parse(callback: (url, error))
                }

                switch result {
                case .success(let token):
                    self?.completed(with: token)
                case .failure:
                    // show error, try to handle
                    break
                }
            }

            let session = ASWebAuthenticationSession(
                url: loginSession.loginURL,
                callbackURLScheme: callbackScheme,
                completionHandler: callback
            )
            session.prefersEphemeralWebBrowserSession = true
            session.presentationContextProvider = self
            self.session = session
            let didStart = session.start()
            if !didStart {
                // present error
            }
        }

        startSession()
    }

    private func completed(with code: OAuthLoginSession.OAuthToken) {
        handleOAuth(code: code, scopes: LoginScopes.allRequired)
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }

    func handleOAuth(code: String, scopes: String) {
        self.authCode = code
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map() { element -> Data in
                return element.data
            }
            .decode(type: Token.self, decoder: SnakeCaseJSONDecoder())
            .sink(
                receiveCompletion: { print ("Received completion: \($0).") },
                receiveValue: { token in
                    self.authToken = token.accessToken
                    self.isLoggedIn = true
                    UserManager.shared.token = token.accessToken
                }
            )
    }

    private var url: URL {
        guard let code = authCode,
              let url = URLBuilder.github()
                .add(paths: ["login", "oauth", "access_token"])
                .add(item: "client_id", value: GITHUB_CLIENT_ID)
                .add(item: "client_secret", value: GITHUB_CLIENT_SECRET)
                .add(item: "code", value: code)
                .url
        else { fatalError("Failed to create login URL") }
        return url
    }
}
