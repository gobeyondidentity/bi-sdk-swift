import Anchorage
import SharedDesign

#if os(iOS)
import UIKit

class AlternateOptionsToSignUpView: View {
    let addToDevice = TextView()
    let recoverAccount = TextView()
    let visitSupport = TextView()
    
    let delegate: TextViewDelegate
    
    init(delegate: TextViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        addToDevice.setTappableText(with: delegate, text: LocalizedString.alternateOptionsAddDeviceText.string, tappableText: LocalizedString.alternateOptionsAddDeviceTappableText.string, for: .addToDevice)
        recoverAccount.setTappableText(with: delegate, text: LocalizedString.alternateOptionsRecoverAccountText.string, tappableText: LocalizedString.alternateOptionsRecoverAccountTappableText.string, for: .recoverAccount)
        visitSupport.setTappableText(with: delegate, text: LocalizedString.alternateOptionsVisitSupportText.string, tappableText: LocalizedString.alternateOptionsVisitSupportTappableText.string, for: .visitSupport)
        
        let stack = StackView(arrangedSubviews: [addToDevice, recoverAccount, visitSupport])
        stack.axis = .vertical
        
        addSubview(stack)
        
        stack.horizontalAnchors == horizontalAnchors
        stack.verticalAnchors == verticalAnchors
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
