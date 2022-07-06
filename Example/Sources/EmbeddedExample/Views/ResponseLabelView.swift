import Anchorage
import UIKit
import SharedDesign

class ResponseLabelView: View {
    let label = UITextView()
    
    var text: String {
        get {
            return label.text ?? ""
        }
        set(newText) {
            label.text = newText
        }
    }
    
    init(){
        super.init(frame: .zero)
        backgroundColor = Colors.empty.value
        
        label.text = "RESPONSE DATA"
        label.font = Fonts.body
        label.textColor = Colors.text.value
        label.isEditable = false
        label.isScrollEnabled = false
        label.backgroundColor = Colors.empty.value
        
        addSubview(label)
        
        label.verticalAnchors == verticalAnchors + Spacing.medium
        label.horizontalAnchors == horizontalAnchors + Spacing.medium
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
