import UIKit
import WebKit

class WebView: WKWebView, WKNavigationDelegate, WKUIDelegate {

    private let preference = WKWebpagePreferences()

    override init(frame: CGRect, configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        super.init(frame: frame, configuration: configuration)

        preference.preferredContentMode = .mobile
        preference.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preference
        navigationDelegate = self
        uiDelegate = self
        allowsBackForwardNavigationGestures = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
