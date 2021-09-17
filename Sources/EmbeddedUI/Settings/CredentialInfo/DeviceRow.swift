import Anchorage
import SharedDesign

#if os(iOS)
class DeviceRow: View {
    let titleLabel = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.body.value)
    
    let infoLabel = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.body.value)
    
    override func layoutSubviews() {
        addBottomBorder()
    }
    
    init(title: String, info: String){
        super.init(frame: .zero)
        
        titleLabel.text = title
        titleLabel.textAlignment = .left
        
        infoLabel.text = info
        infoLabel.textAlignment = .right
        
        let stack = StackView(arrangedSubviews: [titleLabel, Spacer(), infoLabel])
        stack.withMargin(vertical: Spacing.large, horizontal: Spacing.padding)
        
        addSubview(stack)
        
        stack.verticalAnchors == verticalAnchors
        stack.horizontalAnchors == horizontalAnchors
    }
    
    @available(*, unavailable)
    required init?(coder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
