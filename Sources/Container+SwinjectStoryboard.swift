//
//  Container+SwinjectStoryboard.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 11/28/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import Swinject

#if os(iOS) || os(OSX) || os(tvOS)
extension ContainerProtocol {
    /// Adds a registration of the specified view or window controller that is configured in a storyboard.
    ///
    /// - Note: Do NOT explicitly resolve the controller registered by this method.
    ///         The controller is intended to be resolved by `SwinjectStoryboard` implicitly.
    ///
    /// - Parameters:
    ///   - controllerType: The controller type to register as a service type.
    ///                     The type is `UIViewController` in iOS, `NSViewController` or `NSWindowController` in OS X.
    ///   - name:           A registration name, which is used to differentiate from other registrations
    ///                     that have the same view or window controller type.
    ///   - initCompleted:  A closure to specify how the dependencies of the view or window controller are injected.
    ///                     It is invoked by the `Container` when the view or window controller is instantiated by `SwinjectStoryboard`.
    public func storyboardInitCompleted<C: Controller>(_ controllerType: C.Type, name: String? = nil, initCompleted: @escaping (Resolver, C) -> ()) {
        // Xcode 7.1 workaround for Issue #10. This workaround is not necessary with Xcode 7.
        // https://github.com/Swinject/Swinject/issues/10
        let factory = { (_: Resolver, controller: Controller) in controller }
        let wrappingClosure: (Resolver, Controller) -> () = { r, c in initCompleted(r, c as! C) }
        let option = SwinjectStoryboardOption(controllerType: controllerType)
        _register(Controller.self, factory: factory, name: name, option: option)
            .initCompleted(wrappingClosure)
    }
}
#endif


extension ContainerProtocol {
#if os(iOS) || os(tvOS)
    /// The typealias to UIViewController.
    public typealias Controller = UIViewController
    
#elseif os(OSX)
    /// The typealias to AnyObject, which should be actually NSViewController or NSWindowController.
    /// See the reference of NSStoryboard.instantiateInitialController method.
    public typealias Controller = Any
    
#endif
}
