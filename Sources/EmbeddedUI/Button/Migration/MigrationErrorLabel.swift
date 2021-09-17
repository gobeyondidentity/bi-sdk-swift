import SharedDesign

#if os(iOS)
import UIKit

class MigrationErrorLabel: Label {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setWrap()
        setText(LocalizedString.migrationError.string)
        setFont(Fonts.body)
        textColor = Colors.error.value
        textAlignment = .center
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
