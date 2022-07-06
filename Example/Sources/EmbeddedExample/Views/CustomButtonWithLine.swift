import BeyondIdentityEmbedded
import UIKit
import Anchorage
import SharedDesign

class CustomButtonWithLine: Button {
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = Fonts.medium
        label.textColor = Colors.text.value
        return label
    }()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView(image: .chevronRight)
        imageView.setImageColor(color: Colors.disclosure2.value)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        
        buttonLabel.text = title
        
        let stack = StackView(arrangedSubviews: [buttonLabel, Spacer(), iconImage])
        stack.withMargin(vertical: Spacing.large, left: 0, right: Spacing.large)
        stack.isUserInteractionEnabled = false
        
        addSubview(stack)
        
        stack.verticalAnchors == verticalAnchors
        stack.horizontalAnchors == horizontalAnchors
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBottomBorder()
    }
}
