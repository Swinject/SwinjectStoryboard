//
//  ViewController+Swinject.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 7/31/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import ObjectiveC

#if os(iOS) || os(tvOS)

private var uivcRegistrationNameKey: String = "UIViewController.swinjectRegistrationName"
private var uivcWasInjectedKey: String = "UIViewController.wasInjected"
private var uivcShouldBeInjectedKey: String = "UIViewController.shouldBeInjected"

public extension UIViewController {
  
  @IBInspectable
  var isStoryboardInjection: Bool {
    get { return shouldBeInjected }
    set { shouldBeInjected = newValue }
  }
  
}

extension UIViewController: RegistrationNameAssociatable, InjectionVerifiable {
    internal var swinjectRegistrationName: String? {
        get { return getAssociatedString(key: &uivcRegistrationNameKey) }
        set { setAssociatedString(newValue, key: &uivcRegistrationNameKey) }
    }

    internal var wasInjected: Bool {
        get { return getAssociatedBool(key: &uivcWasInjectedKey) ?? false }
        set { setAssociatedBool(newValue, key: &uivcWasInjectedKey) }
    }
  
    internal var shouldBeInjected: Bool {
        get { return getAssociatedBool(key: &uivcShouldBeInjectedKey) ?? false }
        set { setAssociatedBool(newValue, key: &uivcShouldBeInjectedKey) }
    }
}

#elseif os(OSX)

private var nsvcRegistrationNameKey: String = "NSViewController.swinjectRegistrationName"
private var nswcRegistrationNameKey: String = "NSWindowController.swinjectRegistrationName"
private var nsvcWasInjectedKey: String = "NSViewController.wasInjected"
private var nswcWasInjectedKey: String = "NSWindowController.wasInjected"
private var nsvcShouldBeInjectedKey: String = "UIViewController.shouldBeInjected"
private var nswcShouldBeInjectedKey: String = "UIViewController.shouldBeInjected"

public extension NSViewController {
  
  @IBInspectable
  var isStoryboardInjection: Bool {
    get { return shouldBeInjected }
    set { shouldBeInjected = newValue }
  }
  
}

public extension NSWindowController {
  
  @IBInspectable
  var isStoryboardInjection: Bool {
    get { return shouldBeInjected }
    set { shouldBeInjected = newValue }
  }
  
}

extension NSViewController: RegistrationNameAssociatable, InjectionVerifiable {
    internal var swinjectRegistrationName: String? {
        get { return getAssociatedString(key: &nsvcRegistrationNameKey) }
        set { setAssociatedString(newValue, key: &nsvcRegistrationNameKey) }
    }

    internal var wasInjected: Bool {
        get { return getAssociatedBool(key: &nsvcWasInjectedKey) ?? false }
        set { setAssociatedBool(newValue, key: &nsvcWasInjectedKey) }
    }
  
    internal var shouldBeInjected: Bool {
        get { return getAssociatedBool(key: &nsvcShouldBeInjectedKey) ?? false }
        set { setAssociatedBool(newValue, key: &nsvcShouldBeInjectedKey) }
    }
}

extension NSWindowController: RegistrationNameAssociatable, InjectionVerifiable {
    internal var swinjectRegistrationName: String? {
        get { return getAssociatedString(key: &nsvcRegistrationNameKey) }
        set { setAssociatedString(newValue, key: &nsvcRegistrationNameKey) }
    }

    internal var wasInjected: Bool {
        get { return getAssociatedBool(key: &nswcWasInjectedKey) ?? false }
        set { setAssociatedBool(newValue, key: &nswcWasInjectedKey) }
    }
  
    internal var shouldBeInjected: Bool {
        get { return getAssociatedBool(key: &nswcShouldBeInjectedKey) ?? false }
        set { setAssociatedBool(newValue, key: &nswcShouldBeInjectedKey) }
    }
}

#endif

extension NSObject {
    fileprivate func getAssociatedString(key: UnsafeRawPointer) -> String? {
        return objc_getAssociatedObject(self, key) as? String
    }

    fileprivate func setAssociatedString(_ string: String?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, string, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }

    fileprivate func getAssociatedBool(key: UnsafeRawPointer) -> Bool? {
        return (objc_getAssociatedObject(self, key) as? NSNumber)?.boolValue
    }
    
    fileprivate func setAssociatedBool(_ bool: Bool, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, NSNumber(value: bool), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
}
