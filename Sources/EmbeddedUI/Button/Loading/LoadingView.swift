import Anchorage
import SharedDesign

#if os(iOS)
import UIKit

class LoadingView: View {
    private let message = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.body.value)
    
    private let error = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.error.value)
    
    private let errorInfo = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.body.value)
    
    private var isError = false
    private let stack = StackView()
    
    private let offset = Spacing.padding
    
    lazy var eraseLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = Colors.background.value.cgColor
        layer.lineWidth = 6
        return layer
    }()
    
    lazy var lineLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = Colors.primary.value.cgColor
        layer.lineWidth = 5
        return layer
    }()
    
    init() {
        super.init(frame: .zero)
        setUpSubviews()
    }
    
    func setMessage(_ text: String){
        isError = false
        message.text = text
    }
    
    func setError(_ text: String, _ info: String){
        isError = true
        
        error.isHidden = false
        error.text = text
        
        errorInfo.isHidden = false
        errorInfo.text = info
        
        message.isHidden = true
    }
    
    override var bounds: CGRect {
        willSet {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: offset, y: offset))
            path.addLine(to: CGPoint(x: CGFloat(Int(newValue.maxX)) - offset, y: offset))
            eraseLayer.path = path.cgPath
            lineLayer.path = path.cgPath
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureWithShadowBorder(for: .loading)
        
        if eraseLayer.presentation() == nil && lineLayer.presentation() == nil && !isError {
            startAnimation()
        }
        
        if isError {
            stopAnimation()
        }
    }
    
    private func setUpSubviews() {
        message.textAlignment = .center
        error.textAlignment = .center
        errorInfo.textAlignment = .center

        error.isHidden = true
        errorInfo.isHidden = true
        
        stack.addArrangedSubview(message)
        stack.addArrangedSubview(error)
        stack.addArrangedSubview(errorInfo)

        stack.axis = .vertical
        stack.spacing = Spacing.large
        stack.withMargin(margin: Spacing.padding)
        
        addSubview(stack)
        
        stack.horizontalAnchors == horizontalAnchors
        stack.verticalAnchors == verticalAnchors + offset
    }
    
    @available(*, unavailable)
    required init?(coder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoadingView: CAAnimationDelegate {
    enum AnimationType: String {
        case draw
        case erase
    }
    
    func startAnimation(){
        drawLine()
    }
    
    func stopAnimation(){
        eraseLayer.removeAllAnimations()
        lineLayer.removeAllAnimations()
        lineLayer.removeFromSuperlayer()
        eraseLayer.removeFromSuperlayer()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard isError == false else { return }
        
        if anim.value(forKey: "id") as? AnimationType == .draw {
            eraseLayer.removeFromSuperlayer()
            eraseLine()
        }else {
            lineLayer.removeFromSuperlayer()
            drawLine()
        }
    }
    
    func drawLine(){
        lineLayer.add(basicAnimation(for: .draw), forKey: AnimationType.draw.rawValue)
        layer.addSublayer(lineLayer)
    }
    
    func eraseLine(){
        eraseLayer.add(basicAnimation(for: .erase), forKey: AnimationType.erase.rawValue)
        layer.addSublayer(eraseLayer)
    }
    
    private func basicAnimation(for type: AnimationType) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.7
        animation.repeatCount = 1
        animation.delegate = self
        animation.setValue(type, forKey: "id")
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        return animation
    }
    
}
#endif
