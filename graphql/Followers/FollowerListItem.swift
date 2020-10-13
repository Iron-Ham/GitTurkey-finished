//
//  FollowerListItem.swift
//  graphql
//
//  Created by Hesham Salman on 10/13/20.
//

import SwiftUI

struct FollowerListItem: View {
    @State var avatarUrl: String
    @State var login: String
    @State var name: String?
    public var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack {
                    AsyncImage(
                        url: URL(string: avatarUrl)!,
                        placeholder: { ProgressView() },
                        image: { Image(uiImage: $0).resizable() }
                    )
                    .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                    .scaledToFit()
                    .clipShape(Circle())
                    .shadow(radius: 8)
                    .overlay(Circle().stroke(Color.secondary, lineWidth: 2))
                }.padding(.leading)


                VStack(alignment: .leading) {
                    Text("@" + login)
                        .font(.title2)
                        .fontWeight(.ultraLight)
                        .foregroundColor(.primary)

                    if (name != nil) {
                        Text(name!)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }.padding()

                Spacer()
            }
        }
        .padding()
    }

    public init(avatarUrl: String, login: String, name: String?) {
        _avatarUrl = State(initialValue: avatarUrl)
        _login = State(initialValue: login)
        _name = State(initialValue: name)
    }
}

struct FollowerListItem_Previews: PreviewProvider {
    static var previews: some View {
        FollowerListItem(
            avatarUrl: "https://avatars1.githubusercontent.com/u/3388381?s=460&u=767aeeb299a41613663a3408c68cb10cafca079d&v=4",
            login: "Iron-Ham",
            name: "Hesham Salman"
        )
    }
}
