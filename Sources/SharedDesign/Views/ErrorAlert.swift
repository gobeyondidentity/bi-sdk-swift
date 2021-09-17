#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public struct ErrorAlert {
    let dialog: Alert
    
    public init(
        title: String,
        message: String,
        responseTitle: String,
        action: ((UIAlertAction) -> Void)? = nil
    ) {
        #if os(iOS)
        dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: responseTitle, style: .default, handler: action)
        dialog.addAction(action)
        
        #elseif os(macOS)
        dialog = NSAlert()
        dialog.alertStyle = .critical
        dialog.messageText = title
        dialog.informativeText = message
        dialog.addButton(withTitle: responseTitle)
        
        #endif
    }
    
    #if os(iOS)
    public func show(with vc: ViewController){
        vc.present(dialog, animated: true, completion: nil)
    }
    #endif
    
    #if os(macOS)
    public func show(){
        dialog.runModal()
    }
    #endif
    
}
