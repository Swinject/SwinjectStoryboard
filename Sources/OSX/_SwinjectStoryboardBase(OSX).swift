#if os(OSX)
import Cocoa
import Swinject

@objcMembers
public class _SwinjectStoryboardBase: NSStoryboard {
    public class func _create(_ name: String, bundle storyboardBundleOrNil: Bundle?) -> Self {
        let storyboard = perform(Selector.swiftInit("storyboardWithName:bundle:"), with: name, with: storyboardBundleOrNil)?
            .takeUnretainedValue()
        return storyboard as! Self
    }
}

extension SwinjectStoryboard {
    @objc public static func configure() {
        NSStoryboard.swizzling()
        DispatchQueue.once(token: "swinject.storyboard.setup") {
            guard SwinjectStoryboard.responds(to: #selector(SwinjectStoryboard.setup)) else { return }
            SwinjectStoryboard.perform(#selector(SwinjectStoryboard.setup))
        }
    }
}
#endif
