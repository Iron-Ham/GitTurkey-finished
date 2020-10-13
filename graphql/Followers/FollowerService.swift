import Foundation

class FollowerService: ObservableObject {
    @Published var followers: [Follower] = []

    func fetchFollowers() {
        Network.shared.query(
            FollowersQuery(),
            result: {
                $0.viewer.followers.nodes.flatMap { nodes in
                    nodes
                        .compactMap { $0 }
                        .map { Follower(avatarUrl: URL(string: $0.avatarUrl), login: $0.login, name: $0.name) }

                }
            },
            completion: { result in
                switch result {
                case .success(let followers):
                    self.followers = followers
                case .failure(let error):
                    dump(error)
                }
            }
        )
    }

    init(followers: [Follower] = []) {
        self.followers = followers
    }

}
