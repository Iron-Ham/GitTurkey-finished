//
//  FollowersView.swift
//  graphql
//
//  Created by Hesham Salman on 10/13/20.
//

import SwiftUI

struct FollowersView: View {
    @ObservedObject var followerService = FollowerService()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(followerService.followers) { follower in
                        FollowerListItem(
                            avatarUrl: follower.avatarUrl,
                            login: follower.login,
                            name: follower.name
                        )
                    }
                }
            }.navigationBarTitle("Followers")
        }.onAppear(perform: {
            followerService.fetchFollowers()
        })
    }
}

struct FollowersView_Previews: PreviewProvider {
    static var previews: some View {
        FollowersView(followerService: .init(followers: [
            .init(
                avatarUrl: URL(string: "https://avatars1.githubusercontent.com/u/3388381?s=460&u=767aeeb299a41613663a3408c68cb10cafca079d&v=4"),
                login: "Iron-Ham",
                name: "Hesham Salman"
            ),
        ]))
    }
}
