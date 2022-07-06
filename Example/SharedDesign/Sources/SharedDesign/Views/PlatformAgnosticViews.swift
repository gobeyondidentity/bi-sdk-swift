#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

#if os(iOS)
public typealias Alert = UIAlertController
#elseif os(macOS)
public typealias Alert = NSAlert
#endif

#if os(iOS)
public typealias Button = UIButton
#elseif os(macOS)
public typealias Button = NSButton
#endif

public typealias Coder = NSCoder

#if os(iOS)
public typealias Color = UIColor
#elseif os(macOS)
public typealias Color = NSColor
#endif

#if os(iOS)
public typealias Control = UIControl
#elseif os(macOS)
public typealias Control = NSControl
#endif

#if os(iOS)
public typealias EdgeInsets = UIEdgeInsets
#elseif os(macOS)
public typealias EdgeInsets = NSEdgeInsets
#endif

#if os(iOS)
public typealias Font = UIFont
#elseif os(macOS)
public typealias Font = NSFont
#endif

#if os(iOS)
public typealias Image = UIImage
#elseif os(macOS)
public typealias Image = NSImage
#endif

#if os(iOS)
public typealias ImageView = UIImageView
#elseif os(macOS)
public typealias ImageView = NSImageView
#endif

#if os(iOS)
public typealias Label = UILabel
#elseif os(macOS)
public typealias Label = NSTextField
#endif

#if os(iOS)
public typealias LayoutConstraint = NSLayoutConstraint
#elseif os(macOS)
public typealias LayoutConstraint = NSLayoutConstraint
#endif

extension LayoutConstraint {
    public func priority(_ priority: LayoutPriority) -> LayoutConstraint {
        self.priority = priority
        return self
    }
}

#if os(iOS)
public typealias LayoutPriority = UILayoutPriority
#elseif os(macOS)
public typealias LayoutPriority = NSLayoutConstraint.Priority
#endif

#if os(iOS)
public typealias NavigationController = UINavigationController
#elseif os(macOS)
public typealias NavigationController = NSWindowController
#endif


#if os(iOS)
public typealias Responder = UIResponder
#elseif os(macOS)
public typealias Responder = NSResponder
#endif

#if os(iOS)
public typealias StackView = UIStackView
#elseif os(macOS)
public typealias StackView = NSStackView
#endif

#if os(iOS)
public typealias TextField = UITextField
#elseif os(macOS)
public typealias TextField = NSTextField
#endif

#if os(iOS)
public typealias TextView = UITextView
#elseif os(macOS)
public typealias TextView = NSTextView
#endif

#if os(iOS)
public typealias TextViewDelegate = UITextViewDelegate
#elseif os(macOS)
public typealias TextViewDelegate = NSTextViewDelegate
#endif

#if os(iOS)
public typealias ScrollView = UIScrollView
#elseif os(macOS)
public typealias ScrollView = NSScrollView
#endif

#if os(iOS)
public typealias View = UIView
#elseif os(macOS)
public typealias View = NSView
#endif

#if os(iOS)
public typealias ViewController = UIViewController
#elseif os(macOS)
public typealias ViewController = NSViewController
#endif

