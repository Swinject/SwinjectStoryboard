//
//  ViewController+Swinject.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 7/31/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import ObjectiveC

#if canImport(UIKit)
import UIKit

private var uivcRegistrationNameKey: String = "UIViewController.swinjectRegistrationName"
private var uivcWasInjectedKey: String = "UIViewController.wasInjected"

extension UIViewController: RegistrationNameAssociatable, InjectionVerifiable {
    public var swinjectRegistrationName: String? {
        get { return withUnsafePointer(to: &uivcRegistrationNameKey) { getAssociatedString(key: $0) } }
        set { withUnsafePointer(to: &uivcRegistrationNameKey) { setAssociatedString(newValue, key: $0) } }
    }

    public var wasInjected: Bool {
        get { return withUnsafePointer(to: &uivcWasInjectedKey) { getAssociatedBool(key: $0) } ?? false }
        set { withUnsafePointer(to: &uivcWasInjectedKey) { setAssociatedBool(newValue, key: $0) } }
    }
}

#elseif canImport(Cocoa)
import Cocoa

private var nsvcRegistrationNameKey: String = "NSViewController.swinjectRegistrationName"
private var nswcRegistrationNameKey: String = "NSWindowController.swinjectRegistrationName"
private var nsvcWasInjectedKey: String = "NSViewController.wasInjected"
private var nswcWasInjectedKey: String = "NSWindowController.wasInjected"

extension NSViewController: RegistrationNameAssociatable, InjectionVerifiable {
    internal var swinjectRegistrationName: String? {
        get { return withUnsafePointer(to: &nsvcRegistrationNameKey) { getAssociatedString(key: $0) } }
        set { withUnsafePointer(to: &nsvcRegistrationNameKey) { setAssociatedString(newValue, key: $0) } }
    }

    internal var wasInjected: Bool {
        get { return withUnsafePointer(to: &nsvcWasInjectedKey) { getAssociatedBool(key: $0) } ?? false }
        set { withUnsafePointer(to: &nsvcWasInjectedKey) { setAssociatedBool(newValue, key: $0) } }
    }
}

extension NSWindowController: RegistrationNameAssociatable, InjectionVerifiable {
    internal var swinjectRegistrationName: String? {
        get { return withUnsafePointer(to: &nswcRegistrationNameKey) { getAssociatedString(key: $0) } }
        set { withUnsafePointer(to: &nswcRegistrationNameKey) { setAssociatedString(newValue, key: $0) } }
    }

    internal var wasInjected: Bool {
        get { return withUnsafePointer(to: &nswcWasInjectedKey) { getAssociatedBool(key: $0) } ?? false }
        set { withUnsafePointer(to: &nswcWasInjectedKey) { setAssociatedBool(newValue, key: $0) } }
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
