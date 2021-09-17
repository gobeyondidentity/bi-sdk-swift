#if os(iOS)
import UIKit

extension CGPoint {
    func offsetBy(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y + y)
    }
    
    func offsetBy(_ p: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + p, y: self.y + p)
    }
}
#endif
