import SharedDesign

#if os(iOS)
import UIKit

protocol CodeEntryTextFieldDelegate: AnyObject {
    func textFieldDidDelete()
}

class CodeEntryTextField: TextField {
    weak var codeEntryDelegate: CodeEntryTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        codeEntryDelegate?.textFieldDidDelete()
    }
    
    init() {
        super.init(frame: .zero)
        textColor = Colors.heading.value
        font = Fonts.title
        adjustsFontForContentSizeCategory = true
        autocorrectionType = .no
        keyboardType = .default
        autocapitalizationType = .allCharacters
        textAlignment = .center
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.lineWidth = 4
        Colors.heading.value.set()
        path.stroke()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Dash: View {
    init(){
        super.init(frame: .zero)
        backgroundColor = Colors.background.value
    }
    
    override func draw(_ rect: CGRect) {
        let width = floor(rect.width / 4)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX + (width / 2), y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX - (width / 2), y: rect.midY))
        path.lineWidth = 2
        Colors.heading.value.set()
        path.stroke()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
