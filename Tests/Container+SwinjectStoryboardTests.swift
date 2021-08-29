//
//  Container+SwinjectStoryboardTests.swift
//  SwinjectStoryboard
//
//  Created by Yoichi Tagaya on 2021/07/03.
//  Copyright © 2021 Swinject Contributors. All rights reserved.
//

import XCTest
import Swinject

#if os(iOS) || os(OSX) || os(tvOS)

class Container_SwinjectStoryboardTests: XCTestCase {
    func testCustomStringConvertibleDescribesRegistrationWithStoryboardOption() {
        let container = Container()
        let controllerType = String(describing: Container.Controller.self) // "UIViewController" for iOS/tvOS, "AnyObject" for OSX.
        container.storyboardInitCompleted(AnimalViewController.self) { r, c in }

        let expected = "[\n"
            + "    { Service: \(controllerType), Storyboard: SwinjectStoryboardTests.AnimalViewController, "
            + "Factory: (Resolver, \(controllerType)) -> \(controllerType), ObjectScope: graph, InitCompleted: Specified 1 closures }\n"
            + "]"
        XCTAssertEqual(container.description, expected)
    }
}

#endif
