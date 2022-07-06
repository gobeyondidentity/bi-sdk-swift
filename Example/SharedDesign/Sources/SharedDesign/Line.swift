import UIKit

public class Line: UIView {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        addBottomBorder()
    }

    public init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
