import SwiftUI

struct WebView: UIViewControllerRepresentable {

    typealias UIViewControllerType = CustomSafariViewController

    @Binding var url: URL?

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<WebView>
    ) -> CustomSafariViewController {
        return CustomSafariViewController()
    }

    func updateUIViewController(
        _ safariViewController: CustomSafariViewController,
        context: UIViewControllerRepresentableContext<WebView>
    ) {
        safariViewController.url = url // updates our VC's underlying properties
    }

}
