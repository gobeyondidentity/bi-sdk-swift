import SharedDesign

#if os(iOS)
import UIKit

extension UIViewController {
    func dismissAllPreviousViewContollers(completion: (() -> Void)? = nil){
        var firstPresentingVC: UIViewController = self
        
        while let first = firstPresentingVC.presentingViewController {
            firstPresentingVC = first
        }
        
        firstPresentingVC.dismiss(animated: true, completion: {
            if let completion = completion {
                completion()
            }
        })
    }
}
#endif

