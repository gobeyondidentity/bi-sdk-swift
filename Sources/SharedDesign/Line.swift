import UIKit

public class Line: UIView {

    public init() {
        super.init(frame: .zero)
        let border = UIView()
        border.layer.borderWidth = 1
        border.layer.borderColor = Colors.line.value.cgColor
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 0.7)
        addSubview(border)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

