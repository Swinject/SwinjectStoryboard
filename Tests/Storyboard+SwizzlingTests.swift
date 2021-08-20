//
//  Storyboard+SwizzlingTests.swift
//  SwinjectStoryboard
//
//  Created by Yoichi Tagaya on 2021/07/03.
//  Copyright © 2021 Swinject Contributors. All rights reserved.
//

import XCTest
@testable import SwinjectStoryboard

#if os(iOS) || os(tvOS)
private typealias Storyboard = UIStoryboard
private typealias Name = String
#elseif os(OSX)
private typealias Storyboard = NSStoryboard
private typealias Name = NSStoryboard.Name
#endif

#if os(iOS) || os(OSX) || os(tvOS)

class Storyboard_SwizzlingTests: XCTestCase {
    let bundle = Bundle(for: Storyboard_SwizzlingTests.self)

    func testSwinjectStoryboardIsInstantiatedWhenStoryboardIsTriedToBeInstantiated() {
        let storyboard = Storyboard(name: Name("Animals"), bundle: bundle)
        XCTAssert(storyboard is SwinjectStoryboard)
    }
    
    func testSwinjectStoryboardDoesNotHaveInfinitCallsOfSwizzledMethodWhenExplicitlyInstantiated() {
        let storyboard = SwinjectStoryboard.create(name: Name("Animals"), bundle: bundle)
        XCTAssertNotNil(storyboard)
    }
}

#endif
