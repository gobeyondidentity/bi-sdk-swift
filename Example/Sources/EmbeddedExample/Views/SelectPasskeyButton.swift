import Anchorage
import Foundation
import SharedDesign
import UIKit

class SelectPasskeyButton: UIButton {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = Fonts.body
        label.textColor = Colors.text.value
        return label
    }()
    
    private let arrow: UIImageView = {
        let imageView = UIImageView(image: .chevronRight)
        imageView.setImageColor(color: Colors.disclosure2.value)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(text: String) {
        super.init(frame: .zero)
        label.text = text
        
        setUpSubviews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 1.0
        layer.borderColor = Colors.border.value.cgColor
        layer.cornerRadius = 5.0
    }
    func setUpSubviews(){
        let stack = StackView(arrangedSubviews: [label, Spacer(), arrow])
        stack.withMargin(vertical: Spacing.large, horizontal: Spacing.large)
        stack.isUserInteractionEnabled = false
        
        addSubview(stack)
        
        stack.verticalAnchors == verticalAnchors
        stack.horizontalAnchors == horizontalAnchors
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
