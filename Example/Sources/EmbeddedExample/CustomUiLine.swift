import Foundation
import UIKit

class CustomUiLine: UIView {

    private let border = UIView()

    init() {
        super.init(frame: .zero)
        border.layer.borderWidth = 1
        border.layer.borderColor = UIColor(named: Colors.CustomBoarderLine.rawValue)?.cgColor
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 0.7)
        addSubviews()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(border)
    }
}
