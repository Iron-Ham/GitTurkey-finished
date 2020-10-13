import Apollo
import Foundation

class Network {
    static let shared = Network()

    @discardableResult
    public func query<T: GraphQLQuery, Q>(
        _ query: T,
        result: @escaping (T.Data) -> Q?,
        cachePolicy: CachePolicy = .fetchIgnoringCacheData,
        queue: DispatchQueue = .main,
        completion: @escaping (Swift.Result<Q, Error>) -> Void
    ) -> Cancellable {
        return apollo.fetch(query: query, cachePolicy: cachePolicy, queue: DispatchQueue.global(qos: .userInitiated)) { response in

            let mainCompletion = { (result: Swift.Result<Q, Error>) in
                queue.async { completion(result) }
            }

            switch response {
            case .success(let graphQLResult):
                if let data = graphQLResult.data, let q = result(data) {
                    mainCompletion(.success(q))
                } else if let errors = graphQLResult.errors {
                    mainCompletion(.failure(ClientError.serverErrors(errors)))
                } else {
                    mainCompletion(.failure(ClientError.unknown))
                }
            case .failure(let error):
                guard !error.wasCancelled else { return }
                mainCompletion(.failure(error))
            }
        }
    }

    @discardableResult
    public func mutate<T: GraphQLMutation, Q>(
        _ mutation: T,
        result: @escaping (T.Data) -> Q?,
        queue: DispatchQueue = .main,
        completion: @escaping (Swift.Result<Q, Error>) -> Void
    ) -> Cancellable {
        return apollo.perform(mutation: mutation, queue: DispatchQueue.global(qos: .userInitiated)) { response in

            let mainCompletion = { (result: Swift.Result<Q, Error>) in
                queue.async { completion(result) }
            }

            switch response {
            case .success(let graphQLResult):
                if let data = graphQLResult.data, let q = result(data) {
                    mainCompletion(.success(q))
                } else if let errors = graphQLResult.errors {
                    mainCompletion(.failure(ClientError.serverErrors(errors)))
                } else {
                    mainCompletion(.failure(ClientError.unknown))
                }
            case .failure(let error):
                guard !error.wasCancelled else { return }
                mainCompletion(.failure(error))
            }
        }
    }

    private lazy var apollo: ApolloClient = {
        // The cache is necessary to set up the store, which we're going to hand to the provider
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)

        let client = URLSessionClient()
        let provider = NetworkInterceptorProvider(store: store, client: client)
        let url = URL(string: "https://api.github.com/graphql")!

        let requestChainTransport = RequestChainNetworkTransport(
            interceptorProvider: provider,
            endpointURL: url,
            additionalHeaders: [
                "Authorization": "Bearer \(UserManager.shared.token!)"
            ]
        )

        // Remember to give the store you already created to the client so it
        // doesn't create one on its own
        return ApolloClient(networkTransport: requestChainTransport,
                            store: store)
    }()
}


extension Optional where Wrapped: Error {
    var wasCancelled: Bool {
        guard let self = self else { return false }
        return self.wasCancelled
    }
}

extension Error {
    var wasCancelled: Bool {
        if let apolloError = self as? URLSessionClient.URLSessionClientError,
           case let .networkError(data: _, response: _, underlying: underlying) = apolloError {
            return underlying.wasCancelled
        }

        return (self as NSError).code == NSURLErrorCancelled
    }
}
