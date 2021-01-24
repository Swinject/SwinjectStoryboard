#if os(OSX)
import Cocoa

extension NSStoryboard {
    static func swizzling() {
        DispatchQueue.once(token: "swinject.storyboard.init") {
            let aClass: AnyClass = object_getClass(self)!

            let originalSelector = #selector(NSStoryboard.init(name:bundle:))
            let swizzledSelector = #selector(swinject_init(name:bundle:))

            let originalMethod = class_getInstanceMethod(aClass, originalSelector)!
            let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector)!

            let didAddMethod = class_addMethod(aClass, originalSelector,
                                               method_getImplementation(swizzledMethod),
                                               method_getTypeEncoding(swizzledMethod))

            guard didAddMethod else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
                return
            }
            class_replaceMethod(aClass, swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        }
    }

    @objc class func swinject_init(name: String, bundle: Bundle?) -> NSStoryboard {
        guard self == NSStoryboard.self else {
            return self.swinject_init(name: name, bundle: bundle)
        }
        // Instantiate SwinjectStoryboard if NSStoryboard is trying to be instantiated.
        if SwinjectStoryboard.isCreatingStoryboardReference {
            return SwinjectStoryboard.createReferenced(name: name, bundle: bundle)
        } else {
            return SwinjectStoryboard.create(name: name, bundle: bundle)
        }
    }
}
#endif
