import Foundation

class FollowerService: ObservableObject {
    @Published var followers: [Follower] = []

    func fetchFollowers() {
        // Get the followers
    }

}
