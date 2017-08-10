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

extension SwinjectStoryboard {
    
    #if os(iOS) || os(tvOS)
    
    private func injectDependency<Arg>(to viewController: UIViewController, arg: Arg) {
        guard !viewController.wasInjected else { return }
        defer { viewController.wasInjected = true }
        
        let registrationName = viewController.swinjectRegistrationName
        
        // Xcode 7.1 workaround for Issue #10. This workaround is not necessary with Xcode 7.
        // If a future update of Xcode fixes the problem, replace the resolution with the following code and fix storyboardInitCompleted too.
        // https://github.com/Swinject/Swinject/issues/10
        if let container = container.value as? _Resolver {
            let option = SwinjectStoryboardOption(controllerType: type(of: viewController))
            typealias FactoryType = (Resolver, Container.Controller, Arg) -> Container.Controller
            let _ = container._resolve(name: registrationName, option: option) { (factory: FactoryType) in factory(self.container.value, viewController, arg) }
        } else {
            fatalError("A type conforming Resolver protocol must conform _Resolver protocol too.")
        }
        
        for child in viewController.childViewControllers {
            injectDependency(to: child)
        }
    }
    
    public func instantiateViewController<Arg>(withIdentifier identifier: String,
                                          arg: Arg) -> UIViewController {
        SwinjectStoryboard.pushInstantiatingStoryboard(self)
        let viewController = super.instantiateViewController(withIdentifier: identifier)
        SwinjectStoryboard.popInstantiatingStoryboard()
        
        injectDependency(to: viewController, arg: arg)
        
        return viewController
    }
    
    #endif
    
}
