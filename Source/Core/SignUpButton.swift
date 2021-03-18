import Foundation
import UIKit

class SignUpButton: UIControl {
    let imageView = UIImageView(image: .arrowRight)
    let label = UILabel()
    let title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setUpSubviews()

        isAccessibilityElement = true
        accessibilityTraits = .button
        accessibilityLabel = title
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 8
    }

    private func setUpSubviews() {
        imageView.contentMode = .scaleAspectFit
        label.text = title
        label.textColor = .secondaryButtonText
        label.font = UIFont.preferredFont(forTextStyle: .caption1)

        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required - 1, for: .horizontal)

        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.isUserInteractionEnabled = false

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])

        layer.backgroundColor = UIColor.secondaryButtonColor.cgColor
        layer.borderColor = UIColor.secondaryButtonText.cgColor
        layer.borderWidth = 1
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
