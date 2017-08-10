//
//  SwinjectStoryboardExtensions.swift
//  SwinjectStoryboard
//
//  Created by Malkevych Bohdan on 10.08.17.
//  Copyright © 2017 Swinject Contributors. All rights reserved.
//

import Swinject

#if os(iOS) || os(OSX) || os(tvOS)
    extension Container {
        /// Adds a registration of the specified view or window controller that is configured in a storyboard.
        ///
        /// - Note: Do NOT explicitly resolve the controller registered by this method.
        ///         The controller is intended to be resolved by `SwinjectStoryboard` implicitly.
        ///
        /// - Parameters:
        ///   - controllerType: The controller type to register as a service type.
        ///                     The type is `UIViewController` in iOS, `NSViewController` or `NSWindowController` in OS X.
        ///   - name:           A registration name, which is used to differenciate from other registrations
        ///                     that have the same view or window controller type.
        ///   - initCompleted:  A closure to specifiy how the dependencies of the view or window controller are injected.
        ///                     It is invoked by the `Container` when the view or window controller is instantiated by `SwinjectStoryboard`.
        
        public func storyboardInitCompletedArg<C: Controller, Arg>(_ controllerType: C.Type,
                                               name: String? = nil, initCompleted: @escaping (Resolver, C, Arg) -> ()) {
            var arg: Arg!
            let factory = { (_: Resolver, controller: Controller,
                argLocal: Arg) -> Container.Controller in
                arg = argLocal
                return controller
            }
            
            let option = SwinjectStoryboardOption(controllerType: controllerType)
            
            let wrappingClosure: (Resolver, Controller) -> () = { r, c in
                initCompleted(r, c as! C, arg)
            }
            _register(Controller.self, factory: factory, name: name, option: option)
                .initCompleted(wrappingClosure)
        }
    }
#endif
