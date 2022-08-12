import UIKit
import Anchorage
import SharedDesign

class DeveloperDocsViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        view.backgroundColor = Colors.background.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WebView()
        
        DispatchQueue.main.async {
            webView.load(Localized.developerDocsUrl.string)
        }
        
        let stack = UIStackView(arrangedSubviews: [
            webView,
        ]).vertical()
        stack.alignment = .fill
        
        view.addSubview(stack)
        
        stack.horizontalAnchors == view.horizontalAnchors
        stack.verticalAnchors == view.verticalAnchors
        
    }
    
}
