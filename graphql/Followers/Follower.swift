import Foundation

struct Follower: Identifiable {
    let avatarUrl: URL?
    let login: String
    let name: String?

    var id: AnyHashable { login }
}
