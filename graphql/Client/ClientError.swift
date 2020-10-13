import Apollo
import Foundation

public enum ClientError: LocalizedError {
    case unauthorized
    case mismatchedInput
    case serverErrors([GraphQLError])
    case unknown

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "You are unauthorized to make this request."
        case .serverErrors(let errors):
            return errors.map { $0.localizedDescription }.joined(separator: "\n")
        case .mismatchedInput:
            return "There was an error parsing this response."
        case .unknown:
            return "An unknown error occurred."
        }
    }

}
