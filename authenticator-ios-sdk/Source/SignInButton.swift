import Foundation
import UIKit

class SignInButton: UIControl {
    let imageView = UIImageView(image: UIImage(named: "logo"))
    let label = UILabel()
    let title: String
    
    init(title: String){
        self.title = title
        super.init(frame: .zero)
        setUpSubviews()
        
        isAccessibilityElement = true
        accessibilityTraits = .button
        accessibilityLabel = title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 16
    }
    
    private func setUpSubviews(){
        imageView.contentMode = .scaleAspectFit
        label.text = title
        label.textColor = .primaryButtonText
        label.font = UIFont.preferredFont(forTextStyle: .callout)

        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.isUserInteractionEnabled = false
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])
        
        layer.backgroundColor = UIColor.primaryButtonColor.cgColor
        layer.borderColor = UIColor.primaryButtonColor.cgColor
        layer.borderWidth = 1
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
