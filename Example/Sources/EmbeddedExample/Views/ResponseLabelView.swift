import Anchorage
import UIKit
import SharedDesign

class ResponseLabelView: View {
    let label = UITextView()
    let spinner = UIActivityIndicatorView(style: .medium)
    
    var text: String {
        get {
            return label.text ?? ""
        }
        set(newText) {
            label.text = newText
        }
    }
    
    var isLoading: Bool {
        get {
            return true
        }
        set(newBool) {
            if newBool {
                spinner.startAnimating()
            }else {
                spinner.stopAnimating()
            }
        }
    }
    
    /// Reset label text to "RESPONSE DATA"
    func resetLabel(){
        label.text = "RESPONSE DATA"
    }
    
    init(){
        super.init(frame: .zero)
        backgroundColor = Colors.empty.value
        
        resetLabel()
        label.font = Fonts.body
        label.textColor = Colors.text.value
        label.isEditable = false
        label.isScrollEnabled = false
        label.backgroundColor = Colors.empty.value
        
        let stack = UIStackView(arrangedSubviews: [label, spinner])
        
        addSubview(stack)
        
        stack.verticalAnchors == verticalAnchors + Spacing.medium
        stack.horizontalAnchors == horizontalAnchors + Spacing.medium
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
