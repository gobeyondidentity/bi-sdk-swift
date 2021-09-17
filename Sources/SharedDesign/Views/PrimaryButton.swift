import Foundation

public class PrimaryButton: Control {
#if os(iOS)
    let imageView = ImageView(image: .logo)
    let titleLabel = Label()
        .wrap()
        .withFont(Fonts.body)
    
    let subtitleLabel = Label()
        .wrap()
        .withFont(Fonts.caption)
    
    let stackView = StackView()
    
    public init(
        title: String,
        subtitle: String? = nil,
        backgroundColor: Color,
        borderColor: Color,
        imageColor: Color,
        titleColor: Color,
        subtitleColor: Color? = nil
    ) {
        super.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil
        setUpSubviews(
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            imageColor: imageColor,
            titleColor: titleColor,
            subtitleColor: subtitleColor ?? Colors.body.value
        )
        setAccessibility(with: "\(title) \(subtitle ?? "")")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius(for: .small)
    }
    
    private func setUpSubviews(
        backgroundColor: Color,
        borderColor: Color,
        imageColor: Color,
        titleColor: Color,
        subtitleColor: Color
    ) {
        imageView.contentMode = .scaleAspectFit
        imageView.setImageColor(color: imageColor)
        
        titleLabel.textColor = titleColor
        subtitleLabel.textColor = subtitleColor
        
        let textStack = StackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        
        textStack.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textStack)
        stackView.spacing = Spacing.large
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.isUserInteractionEnabled = false
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        LayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium).priority(.defaultLow),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium).priority(.defaultLow),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.medium),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.medium),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        layer.backgroundColor = backgroundColor.cgColor
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1
    }
    
    private func setAccessibility(with title: String) {
        isAccessibilityElement = true
        accessibilityTraits = .button
        accessibilityLabel = title
        
        stackView.isUserInteractionEnabled = false
    }
    
    @available(*, unavailable)
    required init?(coder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
#endif
}
