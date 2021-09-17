import Anchorage
import SharedDesign

#if os(iOS)
import UIKit

class DeviceInfoView: View {
    
    init(){
        super.init(frame: .zero)
        setUpSubviews()
    }
    
    func setUpSubviews() {
        let title = Label()
            .wrap()
            .withFont(Fonts.body)
            .withText(LocalizedString.settingDeviceInfoTitle.string)
            .withColor(Colors.heading.value)
        
        let modelRow = DeviceRow(
            title: LocalizedString.settingDeviceInfoModel.string,
            info: getProductName()
        )
        
        let versionRow = DeviceRow(
            title: LocalizedString.settingDeviceInfoVersion.string,
            info: getVersion()
        )
        
        let deviceStack = StackView(arrangedSubviews: [modelRow, versionRow])
        deviceStack.axis = .vertical
        
        addSubview(title)
        addSubview(deviceStack)
        
        title.topAnchor == topAnchor
        title.horizontalAnchors == horizontalAnchors + Spacing.padding
        deviceStack.topAnchor == title.bottomAnchor + Spacing.medium
        deviceStack.horizontalAnchors == horizontalAnchors
        deviceStack.bottomAnchor == bottomAnchor
    }
    
    func getVersion() -> String {
        let number = UIDevice.current.systemVersion
        var name: String
        #if os(OSX)
        name = "macOS"
        #elseif os(iOS)
        #if targetEnvironment(macCatalyst)
        name = "macOS - Catalyst"
        #else
        name = "iOS"
        #endif
        #endif
        return "\(name) \(number)"
    }
    
    func getProductName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let machineString = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return machineString
    }
    
    @available(*, unavailable)
    required init?(coder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
