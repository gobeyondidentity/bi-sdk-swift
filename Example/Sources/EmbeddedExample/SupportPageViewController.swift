import UIKit
import Anchorage
import BeyondIdentityEmbedded
import SharedDesign

class SupportPageViewController: ViewController {
    private let viewModel: EmbeddedViewModel
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WebView()
        
        DispatchQueue.main.async {
            webView.load(Localized.supportPageUrl.string)
        }
        
        view.addSubview(webView)
        webView.horizontalAnchors == view.horizontalAnchors
        webView.verticalAnchors == view.verticalAnchors
    }
    
}
