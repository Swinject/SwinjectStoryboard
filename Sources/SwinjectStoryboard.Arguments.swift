//
//  Created by Andrew Ayers on 10/22/18
//  Copyright © 2018 Swinject Contributors. All rights reserved.
//

//
// NOTICE:
//
// SwinjectStoryboard.Arguments.swift is generated from SwinjectStoryboard.Arguments.erb by ERB.
// Do NOT modify SwinjectStoryboard.Arguments.swift directly.
// Instead, modify SwinjectStoryboard.Arguments.erb and run `script/gencode` at the project root directory to generate the code.
//


import Swinject
#if os(iOS) || os(tvOS)
extension SwinjectStoryboard {

    private func injectDependency<Arg1>(to viewController: UIViewController, arguments: (Arg1) ) {
        guard !viewController.wasInjected else { return }
        defer { viewController.wasInjected = true }
        
        let registrationName = viewController.swinjectRegistrationName
    
        if let container = container.value as? _Resolver {
            let option = SwinjectStoryboardOption(controllerType: type(of: viewController))
            typealias FactoryType = ((Resolver, Container.Controller, (Arg1))) -> Any
            let _ = container._resolve(name: registrationName, option: option) { (factory: FactoryType) in factory((self.container.value, viewController, arguments)) as Any } as Container.Controller?
        } else {
            fatalError("A type conforming Resolver protocol must conform _Resolver protocol too.")
        }
        
        for child in viewController.children {
            injectDependency(to: child, arguments: arguments)
        }
    }

    private func injectDependency<Arg1, Arg2>(to viewController: UIViewController, arguments: (Arg1, Arg2) ) {
        guard !viewController.wasInjected else { return }
        defer { viewController.wasInjected = true }
        
        let registrationName = viewController.swinjectRegistrationName
    
        if let container = container.value as? _Resolver {
            let option = SwinjectStoryboardOption(controllerType: type(of: viewController))
            typealias FactoryType = ((Resolver, Container.Controller, (Arg1, Arg2))) -> Any
            let _ = container._resolve(name: registrationName, option: option) { (factory: FactoryType) in factory((self.container.value, viewController, arguments)) as Any } as Container.Controller?
        } else {
            fatalError("A type conforming Resolver protocol must conform _Resolver protocol too.")
        }
        
        for child in viewController.children {
            injectDependency(to: child, arguments: arguments)
        }
    }

    private func injectDependency<Arg1, Arg2, Arg3>(to viewController: UIViewController, arguments: (Arg1, Arg2, Arg3) ) {
        guard !viewController.wasInjected else { return }
        defer { viewController.wasInjected = true }
        
        let registrationName = viewController.swinjectRegistrationName
    
        if let container = container.value as? _Resolver {
            let option = SwinjectStoryboardOption(controllerType: type(of: viewController))
            typealias FactoryType = ((Resolver, Container.Controller, (Arg1, Arg2, Arg3))) -> Any
            let _ = container._resolve(name: registrationName, option: option) { (factory: FactoryType) in factory((self.container.value, viewController, arguments)) as Any } as Container.Controller?
        } else {
            fatalError("A type conforming Resolver protocol must conform _Resolver protocol too.")
        }
        
        for child in viewController.children {
            injectDependency(to: child, arguments: arguments)
        }
    }


    public func instantiateViewController<Arg1>(withIdentifier identifier: String,
    arguments: (Arg1)) -> UIViewController {
        let viewController = loadViewController(with: identifier)
        injectDependency(to: viewController, arguments: arguments)
        return viewController
    }


    public func instantiateViewController<Arg1, Arg2>(withIdentifier identifier: String,
    arguments: (Arg1, Arg2)) -> UIViewController {
        let viewController = loadViewController(with: identifier)
        injectDependency(to: viewController, arguments: arguments)
        return viewController
    }


    public func instantiateViewController<Arg1, Arg2, Arg3>(withIdentifier identifier: String,
    arguments: (Arg1, Arg2, Arg3)) -> UIViewController {
        let viewController = loadViewController(with: identifier)
        injectDependency(to: viewController, arguments: arguments)
        return viewController
    }


    private func loadViewController(with identifier: String) -> UIViewController {
        SwinjectStoryboard.pushInstantiatingStoryboard(self)
        let viewController = super.instantiateViewController(withIdentifier: identifier)
        SwinjectStoryboard.popInstantiatingStoryboard()
        return viewController
    }
}
#endif

#if os(OSX)
extension SwinjectStoryboard {
                
    private func injectDependency<Arg1>(to viewController: NSViewController, arguments: (Arg1) ) {
        guard !viewController.wasInjected else { return }
        defer { viewController.wasInjected = true }
        
        let registrationName = viewController.swinjectRegistrationName
        
        if let container = container.value as? _Resolver {
            let option = SwinjectStoryboardOption(controllerType: type(of: viewController))
            typealias FactoryType = ((Resolver, Container.Controller, (Arg1))) -> Any
            let _ = container._resolve(name: registrationName, option: option) { (factory: FactoryType) in factory((self.container.value, viewController, arguments)) as Any } as Container.Controller?
        } else {
            fatalError("A type conforming Resolver protocol must conform _Resolver protocol too.")
        }
        
        for child in viewController.childViewControllers {
            injectDependency(to: child, arguments: arguments)
        }
    }
                
    private func injectDependency<Arg1, Arg2>(to viewController: NSViewController, arguments: (Arg1, Arg2) ) {
        guard !viewController.wasInjected else { return }
        defer { viewController.wasInjected = true }
        
        let registrationName = viewController.swinjectRegistrationName
        
        if let container = container.value as? _Resolver {
            let option = SwinjectStoryboardOption(controllerType: type(of: viewController))
            typealias FactoryType = ((Resolver, Container.Controller, (Arg1, Arg2))) -> Any
            let _ = container._resolve(name: registrationName, option: option) { (factory: FactoryType) in factory((self.container.value, viewController, arguments)) as Any } as Container.Controller?
        } else {
            fatalError("A type conforming Resolver protocol must conform _Resolver protocol too.")
        }
        
        for child in viewController.childViewControllers {
            injectDependency(to: child, arguments: arguments)
        }
    }
                
    private func injectDependency<Arg1, Arg2, Arg3>(to viewController: NSViewController, arguments: (Arg1, Arg2, Arg3) ) {
        guard !viewController.wasInjected else { return }
        defer { viewController.wasInjected = true }
        
        let registrationName = viewController.swinjectRegistrationName
        
        if let container = container.value as? _Resolver {
            let option = SwinjectStoryboardOption(controllerType: type(of: viewController))
            typealias FactoryType = ((Resolver, Container.Controller, (Arg1, Arg2, Arg3))) -> Any
            let _ = container._resolve(name: registrationName, option: option) { (factory: FactoryType) in factory((self.container.value, viewController, arguments)) as Any } as Container.Controller?
        } else {
            fatalError("A type conforming Resolver protocol must conform _Resolver protocol too.")
        }
        
        for child in viewController.childViewControllers {
            injectDependency(to: child, arguments: arguments)
        }
    }
        
                
    public func instantiateController<Arg1>(withIdentifier identifier: NSStoryboard.SceneIdentifier,
    arguments: (Arg1)) -> NSViewController {
        let viewController = loadController(with: identifier) as! NSViewController
        injectDependency(to: viewController, arguments: arguments)
        return viewController
    }
    
                
    public func instantiateController<Arg1, Arg2>(withIdentifier identifier: NSStoryboard.SceneIdentifier,
    arguments: (Arg1, Arg2)) -> NSViewController {
        let viewController = loadController(with: identifier) as! NSViewController
        injectDependency(to: viewController, arguments: arguments)
        return viewController
    }
    
                
    public func instantiateController<Arg1, Arg2, Arg3>(withIdentifier identifier: NSStoryboard.SceneIdentifier,
    arguments: (Arg1, Arg2, Arg3)) -> NSViewController {
        let viewController = loadController(with: identifier) as! NSViewController
        injectDependency(to: viewController, arguments: arguments)
        return viewController
    }
    
        
    private func loadController(with identifier: NSStoryboard.SceneIdentifier) -> Any {
        SwinjectStoryboard.pushInstantiatingStoryboard(self)
        let viewController = super.instantiateController(withIdentifier: identifier)
        SwinjectStoryboard.popInstantiatingStoryboard()
        return viewController
    }
}
#endif

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
    
    public func storyboardInitCompletedArg<C: Controller, Arg1>(_ controllerType: C.Type,
    name: String? = nil, initCompleted: @escaping (Resolver, C, (Arg1)) -> ()) {
        let factory = { (r: Resolver, c: Controller, arguments: (Arg1)) -> Container.Controller in
            initCompleted(r, c as! C, arguments)
            return c
        }
        
        let option = SwinjectStoryboardOption(controllerType: controllerType)
        _register(Controller.self, factory: factory, name: name, option: option)
    }
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
    
    public func storyboardInitCompletedArg<C: Controller, Arg1, Arg2>(_ controllerType: C.Type,
    name: String? = nil, initCompleted: @escaping (Resolver, C, (Arg1, Arg2)) -> ()) {
        let factory = { (r: Resolver, c: Controller, arguments: (Arg1, Arg2)) -> Container.Controller in
            initCompleted(r, c as! C, arguments)
            return c
        }
        
        let option = SwinjectStoryboardOption(controllerType: controllerType)
        _register(Controller.self, factory: factory, name: name, option: option)
    }
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
    
    public func storyboardInitCompletedArg<C: Controller, Arg1, Arg2, Arg3>(_ controllerType: C.Type,
    name: String? = nil, initCompleted: @escaping (Resolver, C, (Arg1, Arg2, Arg3)) -> ()) {
        let factory = { (r: Resolver, c: Controller, arguments: (Arg1, Arg2, Arg3)) -> Container.Controller in
            initCompleted(r, c as! C, arguments)
            return c
        }
        
        let option = SwinjectStoryboardOption(controllerType: controllerType)
        _register(Controller.self, factory: factory, name: name, option: option)
    }
}
#endif
