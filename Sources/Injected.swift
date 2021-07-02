//
//  Injected.swift
//  SwinjectStoryboard
//
//  Created by Alex Frankiv on 17.01.2020.
//  Copyright © 2020 Swinject Contributors. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(OSX)

import Swinject

/// Used for better and more obvious injection since swift 5.1
@propertyWrapper
public struct Injected<T> {

    private let container: Container
    private let name: String?
    private var _wrappedValue: T?

    public var wrappedValue: T? {
        mutating get {
            if self._wrappedValue == nil {
                self._wrappedValue = self.container.resolve(T.self, name: self.name)
            }
            return self._wrappedValue
        }
    }

    public init(initialValue value: T?, container: Container, name: String) {
        self._wrappedValue = value
        self.container = container
        self.name = name
    }

    public init(initialValue value: T?, _ container: Container) {
        self._wrappedValue = value
        self.container = container
        self.name = nil
    }

    public init(initialValue value: T?, _ name: String) {
        self._wrappedValue = value
		self.container = SwinjectStoryboard.defaultContainer
		self.name = name
    }

    public init(wrappedValue value: T?) {
        self._wrappedValue = value
        self.container = SwinjectStoryboard.defaultContainer
        self.name = nil
    }
}

#endif
