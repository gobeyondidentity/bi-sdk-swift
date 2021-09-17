import SharedDesign

#if os(iOS)
class Link: Button {
    init(title: String, for font: Font){
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(Colors.link.value, for: .normal)
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.setFont(font)
    }
    
    @available(*, unavailable)
    required init?(coder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
