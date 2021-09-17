import Anchorage
import SharedDesign

#if os(iOS)
import UIKit

typealias TableData = (title: String, detail: String?, option: SettingOption)

enum SettingOption: String {
    case addCredential
    case viewCredential
    case showQRCode
}

class SettingOptionCell: UITableViewCell {
    let titleLabel = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.body.value)
    
    let detailLabel = Label()
        .wrap()
        .withFont(Fonts.caption)
        .withColor(Colors.body.value)
    
    static let reuseIdentifier = NSStringFromClass(SettingOptionCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: SettingOptionCell.reuseIdentifier)
        
        let textStack = StackView(arrangedSubviews: [titleLabel, detailLabel])
        textStack.axis = .vertical
        textStack.spacing = Spacing.small
        
        let disclosure = ImageView(image: .chevronRight)
        disclosure.contentMode = .scaleAspectFit
        disclosure.setImageColor(color: Colors.disclosure.value)
        
        let stack = StackView(arrangedSubviews: [textStack, Spacer(), disclosure])
        stack .alignment = .center
        stack.distribution = .fill
        
        contentView.addSubview(stack)
        
        stack.verticalAnchors == contentView.verticalAnchors + Spacing.large
        stack.horizontalAnchors == contentView.horizontalAnchors + Spacing.padding
    }
    
    func configure(_ data: TableData) {
        titleLabel.text = data.title
        detailLabel.text = data.detail
        
        detailLabel.isHidden = data.detail == nil  
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif

