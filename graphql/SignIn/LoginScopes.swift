import Foundation

enum LoginScopes {
    static let required = [
        "user",
        "repo",
        "notifications",
        "admin:org",
        "read:discussion",
        "user:assets",
    ]

    static let allRequired = required.joined(separator: "+")
}
