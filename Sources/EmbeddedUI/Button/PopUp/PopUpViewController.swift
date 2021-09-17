import Anchorage
import SharedDesign

#if os(iOS)
import UIKit
class PopUpViewController: ViewController {
    let popUpView: View
    
    init(popUpView: View) {
        self.popUpView = popUpView
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.addSubview(popUpView)
        
        popUpView.centerAnchors == view.centerAnchors
        popUpView.horizontalAnchors == view.horizontalAnchors + Spacing.section
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
