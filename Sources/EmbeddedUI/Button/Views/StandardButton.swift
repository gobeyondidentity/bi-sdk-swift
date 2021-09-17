import SharedDesign

class StandardButton: Button {
    enum State {
        case primary
        case error
    }
    
    #if os(iOS)
    init(title: String, state: State = .primary) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(Colors.standardButtonText.value, for: .normal)
        titleLabel?.setFont(Fonts.body)
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping
        
        switch state {
        case .primary:
            backgroundColor = Colors.primary.value
        case .error:
            backgroundColor = Colors.danger.value
        }
        contentEdgeInsets = EdgeInsets(
            top: Spacing.large,
            left: Spacing.large,
            bottom: Spacing.large,
            right: Spacing.large
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius(for: .small)
    }
    
    @available(*, unavailable)
    required init?(coder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
    #endif
}

