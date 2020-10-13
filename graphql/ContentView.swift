import SwiftUI


struct ContentView: View {
    @EnvironmentObject var oauth: OAuthService

    var body: some View {
        VStack(spacing: grid(2)) {
            AsyncImage(
                url: URL(string: "https://github.githubassets.com/images/modules/logos_page/Octocat.png")!,
                placeholder: { Text("Loading...") },
                image: { Image(uiImage: $0).resizable() }
            )
            .frame(minWidth: 100, maxWidth: 150, minHeight: 100, maxHeight: 150)
            .scaledToFit()
            .shadow(radius: 8)
            .padding()

            Text("GitTurkey 🦃")
                .font(.largeTitle)
                .fontWeight(.ultraLight)
                .foregroundColor(.primary)

            Text("View your followers")
                .font(.subheadline)
                .foregroundColor(.primary)
                .fontWeight(.ultraLight)

            Button("Sign in", action: { self.oauth.onSignInButton() })
                .buttonStyle(ActionButtonStyle())
                .padding()
        }
        .fullScreenCover(isPresented: self.$oauth.isLoggedIn) {
            FollowersView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
