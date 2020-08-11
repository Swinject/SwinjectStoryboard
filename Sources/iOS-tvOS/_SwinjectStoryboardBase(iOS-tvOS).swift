#if os(iOS) || os(tvOS)
import UIKit
import Swinject

@objcMembers
public class _SwinjectStoryboardBase: UIStoryboard {

    public class func _create(_ name: String, bundle storyboardBundleOrNil: Bundle?) -> Self {
        let storyboard = perform(Selector.swiftInit("storyboardWithName:bundle:"), with: name, with: storyboardBundleOrNil)?
            .takeUnretainedValue()
        return storyboard as! Self
    }
}

extension SwinjectStoryboard {
    @objc public static func configure() {
        UIStoryboard.swizzling()
        DispatchQueue.once(token: "swinject.storyboard.setup") {
            guard SwinjectStoryboard.responds(to: _Selector("setup")) else { return }
            SwinjectStoryboard.perform(_Selector("setup"))
        }
    }

    static func _Selector(_ str: String) -> Selector {
        return Selector(str)
    }
}
#endif
