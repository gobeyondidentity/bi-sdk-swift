import Foundation
import SharedDesign

class SignUpButton: Control {
    #if os(iOS)
    let imageView = ImageView(image: .arrowRight)
    let label = Label()
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
        setCornerRadius(for: .small)
    }

    private func setUpSubviews() {
        imageView.contentMode = .scaleAspectFit
        label.text = title
        label.textColor = .secondaryButtonText
        label.font = Fonts.body

        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(LayoutPriority(rawValue: LayoutPriority.required.rawValue - 1), for: .horizontal)

        let stackView = StackView(arrangedSubviews: [label, imageView])
        stackView.spacing = Spacing.medium
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.isUserInteractionEnabled = false

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        LayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.medium),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.medium)
        ])

        layer.backgroundColor = Color.secondaryButtonColor.cgColor
        layer.borderColor = Color.secondaryButtonText.cgColor
        layer.borderWidth = 1
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    #endif
}
