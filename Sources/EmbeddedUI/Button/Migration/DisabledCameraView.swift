import Anchorage
import SharedDesign

class DisabledCameraView: View {
    let icon = ImageView(image: .accessDenied)
    
    let label = Label()
        .wrap()
        .withText(LocalizedString.migrationCameraDisabled.string)
        .withFont(Fonts.title)
        .withColor(Colors.emptyText.value)

    override func layoutSubviews() {
        icon.heightAnchor == bounds.height / 3
    }
    
    init(){
        super.init(frame: .zero)
        backgroundColor = Colors.empty.value
        
        icon.contentMode = .scaleAspectFit
        icon.setImageColor(color: Colors.emptyText.value)
        
        label.textAlignment = .center
        
        let stack = StackView(arrangedSubviews: [icon, label])
        stack.axis = .vertical
        stack.spacing = Spacing.large

        addSubview(stack)
        
        stack.centerXAnchor == centerXAnchor
        stack.centerYAnchor == centerYAnchor
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
