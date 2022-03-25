import BeyondIdentityEmbedded
import UIKit
import Anchorage
import SharedDesign

class CustomButtonWithLine: UIButton {

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    private let iconImage: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.tintColor = Colors.navBarText.value
        imageView.contentMode = .scaleAspectFit
        return imageView

    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(title: String) {
        super.init(frame: .zero)
        clipsToBounds = true
        layer.cornerRadius = 4
        contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        addBottomBorder(Colors.line.value, height: 1.0)
        buttonLabel.text = title
        buttonLabel.font = Fonts.medium
        buttonLabel.textColor = .label
        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(buttonLabel)
        addSubview(iconImage)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        buttonLabel.frame = CGRect(x: 0, y: 11, width: frame.size.width, height: frame.size.height/2)
        iconImage.frame = CGRect(x: frame.size.width/2 - 24, y: 10, width: frame.size.width, height: frame.size.height/2)
    }
}

extension UIView {
func addBottomBorder(_ color: UIColor, height: CGFloat) {
       let border = UIView()
       border.backgroundColor = color
       self.addSubview(border)
       border.heightAnchor == 1
       border.widthAnchor == self.widthAnchor
       border.bottomAnchor == self.bottomAnchor
   }
}
