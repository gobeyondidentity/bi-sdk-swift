import Anchorage
import Foundation
import SharedDesign
import UIKit

class Card: UIView {
    let title: String
    let detail: String
    let cardView: UIView
    
    init(title: String, detail: String, cardView: UIView){
        self.title = title
        self.detail = detail
        self.cardView = cardView
        super.init(frame: .zero)
        setUpSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubviews() {
        let stack = UIStackView(arrangedSubviews: [
            UILabel().wrap().withText(title).withFont(Fonts.title),
            UILabel().wrap().withText(detail).withFont(Fonts.title2),
            cardView
        ]).vertical()
        
        addSubview(stack)
        
        stack.horizontalAnchors == horizontalAnchors
        stack.verticalAnchors == verticalAnchors
        stack.alignment = .fill
    }
}


