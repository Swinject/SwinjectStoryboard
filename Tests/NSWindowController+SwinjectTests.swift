//
//  NSWindowController+SwinjectTests.swift
//  SwinjectStoryboard
//
//  Created by Yoichi Tagaya on 2021/07/03.
//  Copyright © 2021 Swinject Contributors. All rights reserved.
//

#if os(OSX)

import XCTest
@testable import SwinjectStoryboard

class NSWindowController_SwinjectTests: XCTestCase {
    func testPropertyToStoreSwinjectContainerRegistrationName() {
        let controller1 = NSWindowController(window: nil)
        let controller2 = NSWindowController(window: nil)
        controller1.swinjectRegistrationName = "1"
        controller2.swinjectRegistrationName = "2"
        
        XCTAssertEqual(controller1.swinjectRegistrationName, "1")
        XCTAssertEqual(controller2.swinjectRegistrationName, "2")
    }
}

#endif
