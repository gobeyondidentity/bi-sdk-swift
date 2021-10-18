import SharedDesign

#if os(iOS)
import UIKit

extension UIViewController {
    func dismissAllPreviousCustomViewContollers(completion: (() -> Void)? = nil){
        if let first = self.navigationController?.viewControllers.first {
            first.dismiss(animated: true, completion: {
                if let completion = completion {
                    completion()
                }
            })
        }
    }
}
#endif
