//
//  Container+SwinjectStoryboardSpec.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 2/27/16.
//  Copyright © 2016 Swinject Contributors. All rights reserved.
//

import Quick
import Nimble
import Swinject

#if os(iOS) || os(OSX) || os(tvOS)
class Container_SwinjectStoryboardSpec: QuickSpec {
    override func spec() {
        var container: Container!
        beforeEach {
            container = Container()
        }
        
        describe("CustomStringConvertible") {
            it("describes a registration with storyboard option.") {
                let controllerType = String(describing: Container.Controller.self) // "UIViewController" for iOS/tvOS, "AnyObject" for OSX.
                container.storyboardInitCompleted(AnimalViewController.self) { r, c in }

                expect(container.description) ==
                    "[\n"
                    + "    { Service: \(controllerType), Storyboard: SwinjectStoryboardTests.AnimalViewController, "
                    + "Factory: ((Resolver, \(controllerType))) -> \(controllerType), ObjectScope: graph, InitCompleted: Specified }\n"
                    + "]"
            }
        }
    }
}
#endif
