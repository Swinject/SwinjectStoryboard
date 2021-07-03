//
//  ViewController+SwinjectTests.swift
//  SwinjectStoryboard
//
//  Created by Yoichi Tagaya on 2021/07/03.
//  Copyright © 2021 Swinject Contributors. All rights reserved.
//

import XCTest
@testable import SwinjectStoryboard

#if os(iOS) || os(tvOS)
private let createViewController = { UIViewController(nibName: nil, bundle: nil) }
#elseif os(OSX)
private let createViewController = { NSViewController(nibName: nil, bundle: nil) }
#endif

#if os(iOS) || os(OSX) || os(tvOS)

class ViewController_SwinjectTests: XCTestCase {

    func testPropertyToStoreSwinjectContainerRegistrationName() {
        let viewController1 = createViewController()
        let viewController2 = createViewController()
        viewController1.swinjectRegistrationName = "1"
        viewController2.swinjectRegistrationName = "2"
        
        XCTAssertEqual(viewController1.swinjectRegistrationName, "1")
        XCTAssertEqual(viewController2.swinjectRegistrationName, "2")
    }
}

#endif
