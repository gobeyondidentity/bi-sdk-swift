import Anchorage
import Foundation
import SharedDesign

class RecoverInsteadOfMigrate: View {
    #if os(iOS)
    let recoverUserAction: () -> Void
    
    init(recoverUserAction: @escaping () -> Void) {
        self.recoverUserAction = recoverUserAction
        super.init(frame: .zero)
        setUpSubviews()
    }
    
    func setUpSubviews() {
        let recoverDescription = Label()
            .wrap()
            .withText(LocalizedString.migrationSwitchToRecoverDescription.string)
            .withFont(Fonts.caption)
            .withColor(Colors.body.value)
        
        recoverDescription.textAlignment = .center
        
        let switchToRecoverButton = Link(title: LocalizedString.alternateOptionsRecoverAccountTappableText.string, for: Fonts.caption)
        switchToRecoverButton.addTarget(self, action: #selector(tapSwitchToRecover), for: .touchUpInside)
        
        let recoverStack = StackView(arrangedSubviews: [recoverDescription, switchToRecoverButton])
        recoverStack.axis = .vertical
        
        addSubview(recoverStack)
        
        recoverStack.verticalAnchors == verticalAnchors
        recoverStack.horizontalAnchors == horizontalAnchors
    }
    
    @objc func tapSwitchToRecover() {
        recoverUserAction()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
    #endif
}
