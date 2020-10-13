import SwiftUI

struct ContentView: View {
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

            Text("GitBird")
                .font(.largeTitle)
                .fontWeight(.ultraLight)
                .foregroundColor(.primary)

            Text("View your followers")
                .font(.subheadline)
                .foregroundColor(.primary)
                .fontWeight(.ultraLight)

            Button("Log in", action: { })
                .buttonStyle(ActionButtonStyle())
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
