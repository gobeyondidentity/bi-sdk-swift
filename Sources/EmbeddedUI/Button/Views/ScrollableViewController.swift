import Anchorage
import SharedDesign

#if os(iOS)
import UIKit

class ScrollableViewController: ViewController {
    let contentView = UIView()
    let scrollView = UIScrollView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.widthAnchor == view.widthAnchor
        scrollView.verticalAnchors == view.verticalAnchors
        
        contentView.widthAnchor == scrollView.widthAnchor
        contentView.verticalAnchors == scrollView.verticalAnchors
    }
}

#endif
