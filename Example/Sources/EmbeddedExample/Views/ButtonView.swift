import Anchorage
import SharedDesign
import UIKit

class ButtonView: UIView {
    let button: Button
    let buttonAction: (@escaping (String) -> Void) async -> Void
    let label: ResponseLabelView
    
    /// ButtonView: UIView
    /// - Parameters:
    ///   - buttonTitle: Button Title
    ///   - buttonAction: When button taps, this action will run passing the caller a function that when given a String will print to the label
    init(
        buttonTitle: String,
        buttonAction: @escaping (@escaping (String) -> Void) async -> Void
    ) {
        button = makeButton(with: buttonTitle)
        label = ResponseLabelView(buttonTitle)

        self.buttonAction = buttonAction
        super.init(frame: .zero)
        setUpSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubviews() {
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        let stack = UIStackView(arrangedSubviews: [
            button,
            label,
        ]).vertical()
        
        addSubview(stack)
        
        stack.horizontalAnchors == horizontalAnchors
        stack.verticalAnchors == verticalAnchors
        stack.alignment = .fill
    }
    
    @objc func onTap() {
        self.label.isLoading = true
        self.label.resetLabel()
        Task {
            await buttonAction() { [weak self] text in
                self?.label.text = text
                self?.label.isLoading = false
            }
        }
    }
}
