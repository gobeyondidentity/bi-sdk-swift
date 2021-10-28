import SharedDesign

#if os(iOS)
import UIKit

extension UIViewController {
    func dismissAllPreviousCustomViewContollers(completion: (() -> Void)? = nil) {
        // Dismiss all view controllers from CustomNavigationController
        if let firstCustomViewController = (navigationController as? CustomNavigationController)?.viewControllers.first  {
            firstCustomViewController.dismiss(animated: true, completion: {
                if let completion = completion {
                    completion()
                }
            })
        }else {
            // If no CustomNavigationController then assumes only one presenting view controller (in the case of registration)
            self.dismiss(animated: true, completion: {
                if let completion = completion {
                    completion()
                }
            })
        }
    }
}
#endif
